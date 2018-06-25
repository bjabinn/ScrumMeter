import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ChartsModule } from 'ng2-charts/ng2-charts';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { SectionInfo } from 'app/Models/SectionInfo';
import { RespuestaConNotas } from 'app/Models/RespuestaConNotas';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { SectionService } from 'app/services/SectionService';
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
  public Evaluacion: EvaluacionInfo;
  public Mostrar = false;
  public ErrorMessage = null;
  //Datos de la barras
  public barChartType: string = 'bar';
  public barChartLegend: boolean = true;
  public ListaNPreguntas: number[] = [];
  public ListaNRespuestas: number[] = [];
  public ListaNombres: string[] = [];

  //Para las notas
  public mostrarCheckboxes: boolean = true;
  public mostrarNotasEv: boolean = false;
  public mostrarNotasOb: boolean = false;
  public mostrarNotasSec: boolean = false;
  public mostrarNotasPreg: boolean = false;
  public ListaDeRespuestas: Array<RespuestaConNotas> = [];
  public cargandoNotasPreg: boolean = false;


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

  }

  ngOnInit() {

    //Recoge los datos de las secciones
    if (this.Evaluacion != null && this.Evaluacion != undefined) {
      this._sectionService.getSectionInfo(this.Evaluacion.id).subscribe(
        res => {
          this.ListaDeDatos = res;
          this.shareDataToChart();
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: ", error, "No pudimos recoger los datos de la sección lo sentimos.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: ", error, " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        }
      );
    } else {
      this._router.navigate(['/home']);
    }

  }

  //Da los datos a las diferentes listas que usaremos para las graficas
  public shareDataToChart() {
    for (var i = 0; i < this.ListaDeDatos.length; i++) {
      this.ListaNombres.push(this.ListaDeDatos[i].nombre);
      this.ListaNPreguntas.push(this.ListaDeDatos[i].preguntas);
      this.ListaNRespuestas.push(/*this.ListaDeDatos[i].respuestas*/1);
    }
    this.Mostrar = true;
  }

  //Datos para la grafica
  public barChartOptions: any = {
     scaleShowVerticalLines: true,
     responsive: true
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
    //this.mostrarCheckboxes = false;

    var date = this.datePipe.transform(this.Evaluacion.fecha, 'MM-dd-yyyy');
    var nombre = this.Evaluacion.nombre;
    /*document.title = this.Evaluacion.nombre + date + "AgileMeter";
    window.print();*/

    //Para que de tiempo a ocultar el panel de las checkboxes
    setTimeout(()=>{
      html2canvas(document.getElementById("printcanvas")).then(function (canvas) {
        var img = canvas.toDataURL("image/png");
        var doc = new jsPDF();
        doc.addImage(img, 'PNG', 15, 20, 0, 0);

        var title = nombre + '.' + date + '.' + 'AgileMeter.pdf';
        doc.save(title);

      });
      //this.mostrarCheckboxes = true;
    }, 500);


  }

  public cambiarMostrarNotasEv() {
    this.mostrarNotasEv = !this.mostrarNotasEv;
  }

  public cambiarMostrarNotasOb() {
    this.mostrarNotasOb = !this.mostrarNotasOb;
  }

  public cambiarMostrarNotasSec() {
    this.mostrarNotasSec = !this.mostrarNotasSec;
  }

  public cambiarMostrarNotasPreg() {

    //No se ha hecho la peticion al servidor aun
    if (!this.mostrarNotasPreg && this.ListaDeRespuestas.length == 0) {
      this.cargandoNotasPreg = true;

      this._sectionService.getRespuestasConNotas(this.Evaluacion.id).subscribe(
        res => {
          this.ListaDeRespuestas = res;
          this.cargandoNotasPreg = false;
          this.mostrarNotasPreg = true;
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: ", error, "No pudimos recoger los datos de las preguntas.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: ", error, " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        }
      );
    }
    else {
          this.mostrarNotasPreg = !this.mostrarNotasPreg;
      }

  }

  public Volver(lugar) {
    this._router.navigate([lugar]);
  }
}
