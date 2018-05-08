import { Component, OnInit } from '@angular/core';
import { ChartsModule } from 'ng2-charts/ng2-charts';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { SectionInfo } from 'app/Models/SectionInfo';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { SectionService } from 'app/services/SectionService';
import { forEach } from '@angular/router/src/utils/collection';

@Component({
  selector: 'app-pdfgenerator',
  templateUrl: './pdfgenerator.component.html',
  styleUrls: ['./pdfgenerator.component.scss'],
  providers: [SectionService]
})
export class PdfgeneratorComponent implements OnInit {

  public ListaDeDatos: Array<SectionInfo> = [];
  public UserName: string = "";
  public Project: Proyecto = null;
  public Evaluacion: EvaluacionInfo = null;
  //Datos de la barras
  public barChartType: string = 'bar';
  public barChartLegend: boolean = true;
  public ListaNPreguntas: number[] = [];
  public ListaNRespuestas: number[] = [];
  public ListaNombres: string[] = [];

  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    private _sectionService: SectionService) { }

  ngOnInit() {

    //Recupera los datos y los comprueba
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    this.Evaluacion = this._appComponent._storageDataService.EvaluacionToPDF;
    console.log("dale desde principio: ", this.Evaluacion, "o no vea: ", this._appComponent._storageDataService.EvaluacionToPDF)
    if (this._appComponent._storageDataService.UserData == undefined || this._appComponent._storageDataService.UserData == null) {
      this.UserName = localStorage.getItem("user");
      if (this.UserName == undefined || this.UserName == null || this.UserName == "") {
        this._router.navigate(['/login']);
      }
      if (this.Project == null || this.Project == undefined || this.Evaluacion == null || this.Evaluacion == undefined) {
        this._router.navigate(['/home']);
      }
    } else {
      this.UserName = this._appComponent._storageDataService.UserData.nombre;
    }

    //Recoge los datos del servicio
    console.log("le esta pasando: ", this.Evaluacion.estado)
    this._sectionService.getSectionInfo(this.Evaluacion.id).subscribe(
      res => {
        this.ListaDeDatos = res;
        this.shareDataToChart();
      },
      error => {
        console.log("Error al recoger los datos.")
      }
    );
  }

  //Da los datos a las diferentes listas que usaremos para las graficas
  public shareDataToChart() {
    for (var i = 0; i < this.ListaDeDatos.length; i++) {
      console.log("dentro del for: ", this.ListaDeDatos[i])
      this.ListaNombres.push(this.ListaDeDatos[i].nombre);
      this.ListaNPreguntas.push(this.ListaDeDatos[i].preguntas);
      this.ListaNRespuestas.push(this.ListaDeDatos[i].respuestas);
    }
    console.log("investiga muchos array: ", this.ListaNombres, this.ListaNPreguntas, this.ListaNRespuestas)
  }

  //Datos para la grafica
  public barChartOptions: any = {
    scaleShowVerticalLines: false,
    responsive: true
  };


  public barChartData: any[] = [
    { data: this.ListaNPreguntas, label: 'Nº total de preguntas' },
    { data: this.ListaNRespuestas, label: 'Preguntas Respondidas' }
  ];

  // eventos
  public chartClicked(e: any): void {
    console.log(e);
  }

  public chartHovered(e: any): void {
    console.log(e);
  }
}
