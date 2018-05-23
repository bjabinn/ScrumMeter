import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ChartsModule } from 'ng2-charts/ng2-charts';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { SectionInfo } from 'app/Models/SectionInfo';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { SectionService } from 'app/services/SectionService';
import { LoadingComponent } from '../loading/loading.component';
import { DatePipe } from '@angular/common';
import { ProyectoService } from 'app/services/ProyectoService';

import * as jsPDF from 'jspdf';
import * as html2canvas from 'html2canvas';

@Component({
  selector: 'app-pdfgenerator',
  templateUrl: './pdfgenerator.component.html',
  styleUrls: ['./pdfgenerator.component.scss'],
  providers: [SectionService, ProyectoService, DatePipe]
})
export class PdfgeneratorComponent implements OnInit {

  public ListaDeDatos: Array<SectionInfo> = [];
  public UserName: string = "";
  public Project: Proyecto = null;
  public Evaluacion: EvaluacionInfo = null;
  public Mostrar = false;
  //Datos de la barras
  public barChartType: string = 'bar';
  public barChartLegend: boolean = true;
  public ListaNPreguntas: number[] = [];
  public ListaNRespuestas: number[] = [];
  public ListaNombres: string[] = [];
  public valueResponsive: boolean = true;

  //Datos para pdf
  @ViewChild('content') content: ElementRef;

  constructor(
    private _proyectoService: ProyectoService,
    private _appComponent: AppComponent,
    private _router: Router,
    private _sectionService: SectionService,
    private datePipe: DatePipe) {

    //Recupera los datos y los comprueba
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    this.Evaluacion = this._appComponent._storageDataService.EvaluacionToPDF;
    this._proyectoService.verificarUsuario();
    this.UserName = this._proyectoService.UsuarioLogeado;

    if (this.Evaluacion == null || this.Evaluacion == undefined || this.Project == null || this.Project == undefined) {

      this._router.navigate(['/home']);

    } else if (this.Evaluacion.id == null) {

      this._router.navigate(['/home']);

    }

    var ArrayRoles = [];
    this._proyectoService.getRolesUsuario().subscribe(
      res => {
        var AdminOn = false;
        ArrayRoles = res;
        //Si no hay errores y son recogidos busca si tienes permisos de usuario
        for (let num = 0; num < ArrayRoles.length; num++) {
          if (ArrayRoles[num].role == "Administrador") {
            AdminOn = true;
          }
        }
        if (this.Project.id == null && !AdminOn) {
          this._router.navigate(['/home']);
        }
      },
      error => {
        this._router.navigate(['/home']);
      });

    //Recoge los datos del servicio
    if (this.Evaluacion != null && this.Evaluacion != undefined) {
      this._sectionService.getSectionInfo(this.Evaluacion.id).subscribe(
        res => {
          this.ListaDeDatos = res;
          this.shareDataToChart();
        },
        error => {
          console.log("Error al recoger los datos.")
        }
      );
    } else {
      this._router.navigate(['/home']);
    }

  }

  ngOnInit() {

  }

  //Da los datos a las diferentes listas que usaremos para las graficas
  public shareDataToChart() {
    for (var i = 0; i < this.ListaDeDatos.length; i++) {
      this.ListaNombres.push(this.ListaDeDatos[i].nombre);
      this.ListaNPreguntas.push(this.ListaDeDatos[i].preguntas);
      this.ListaNRespuestas.push(this.ListaDeDatos[i].respuestas);
    }
    this.Mostrar = true;
  }

  //Datos para la grafica
  public barChartOptions: any = {
    scaleShowVerticalLines: true,
    responsive: this.valueResponsive
  };

  //Estos son los datos introducidos en la grafica para que represente sus formas
  public barChartData: any[] = [
    { data: this.ListaNPreguntas, label: 'Nº total de preguntas' },
    { data: this.ListaNRespuestas, label: 'Preguntas Respondidas' }
  ];

  public chartHovered(e: any): void {
    console.log(e);
  }

  //Genera un pdf a partir de una captura de pantalla
  //Mediante css eliminamos los componentes que no deseamos
  public downloadPDF() {
    var date = this.datePipe.transform(this.Evaluacion.fecha, 'MM-dd-yyyy');
    /*document.title = this.Evaluacion.nombre + date + "ScrumMeter";
    window.print();*/
    html2canvas(document.getElementById("printcanvas")).then(function (canvas) {
      var img = canvas.toDataURL("image/png");
      var doc = new jsPDF();
      doc.addImage(img, 'JPEG', 0, 20, 220, 150);
      doc.save(this.Evaluacion.nombre + date + 'ScrumMeter.pdf');
    });

  }
}
