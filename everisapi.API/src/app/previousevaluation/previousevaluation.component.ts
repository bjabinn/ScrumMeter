import { Component, OnInit } from '@angular/core';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { EvaluacionService } from '../services/EvaluacionService';
import { Evaluacion } from 'app/Models/Evaluacion';

@Component({
  selector: 'app-previousevaluation',
  templateUrl: './previousevaluation.component.html',
  styleUrls: ['./previousevaluation.component.scss'],
  providers: [EvaluacionService]
})
export class PreviousevaluationComponent implements OnInit {
  public clicked: boolean = true;
  public EvaluacionBuscada: EvaluacionInfo =
    { 'id': null, 'nombre': '', 'estado': null, 'fecha': '', 'userNombre': null, 'npreguntas': null, 'nrespuestas': null };
  public ListaDeEvaluaciones: Array<EvaluacionInfo>;
  public nrespuestas: string;
  public FiltrarCompletados: boolean = null;
  public UserName: string = "";
  public Project: Proyecto = { 'id': null, 'nombre': '', 'fecha': '' };
  

  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    private _evaluacionService: EvaluacionService) { }

  ngOnInit() {
    this.Restablecer();
    //Datos de prueba
    /*this.ListaDeEvaluaciones = [new EvaluacionInfo( 1 ,'TESCO', 'User', 100, 100, "12/11/2018", true),
      new EvaluacionInfo( 2, 'BSA', 'Admin', 65, 55, "24/10/2015", false),
      new EvaluacionInfo( 3, 'FacePalms', 'Admin', 100, 100, "09/03/2012", false),
      new EvaluacionInfo( 4, 'NextDay', 'User', 50, 32, "11/01/2016", true)];*/

    //Recogemos los proyectos y realizamos comprobaciones
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    if (this._appComponent._storageDataService.UserData == undefined || this._appComponent._storageDataService.UserData == null) {
      this.UserName = localStorage.getItem("user");
      if (this.UserName == undefined || this.UserName == null || this.UserName == "") {
        this._router.navigate(['/login']);
      }
      if (this.Project == null || this.Project == undefined) {
        this._router.navigate(['/home']);
      }
    } else {
      this.UserName = this._appComponent._storageDataService.UserData.nombre;
    }

    //Recoge la información extendida necesaria para la lista de evaluaciones
    this._evaluacionService.getEvaluacionInfo(this.Project.id).subscribe(
      res => {
        this.ListaDeEvaluaciones = res;
        console.log("Listado Evaluaciones: ", this.ListaDeEvaluaciones)
      },
      error => {
        console.log("Error recoger listado de evaluaciones: "+error)
      });
    
  }

  //Restablece los datos de la busqueda
  public Restablecer() {
    if (this.clicked) {
      this.EvaluacionBuscada.fecha = "";
      this.EvaluacionBuscada.nombre = "";
      this.EvaluacionBuscada.userNombre = "";
      this.EvaluacionBuscada.npreguntas = null;
      this.EvaluacionBuscada.nrespuestas = null;
      this.EvaluacionBuscada.estado = null;
      this.nrespuestas = '';
      this.clicked = false;
    } else {
      this.clicked = true;
    }
  }

  //Utiliza los datos del filtrado para realizar un filtrado en el array
  public Busqueda() {
    var BuscaPersonalizada: Array<EvaluacionInfo> = this.ListaDeEvaluaciones;
    //Si no filtra por completos o incompletos
    if (this.FiltrarCompletados == null) {
      BuscaPersonalizada = this.ListaDeEvaluaciones.filter(
        x => x.fecha.includes(this.EvaluacionBuscada.fecha) &&
        x.nombre.includes(this.EvaluacionBuscada.nombre) &&
          x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
        String(x.nrespuestas).includes(this.nrespuestas));
    } else {
      //Filtrando por completos
      if (this.FiltrarCompletados) {
        BuscaPersonalizada = this.ListaDeEvaluaciones.filter(
          x => x.estado &&
          x.fecha.includes(this.EvaluacionBuscada.fecha) &&
          x.nombre.includes(this.EvaluacionBuscada.nombre) &&
            x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
          String(x.nrespuestas).includes(this.nrespuestas));
      } else {
        //Filtrando por incompletos
        BuscaPersonalizada = this.ListaDeEvaluaciones.filter(
          x => !x.estado &&
          x.fecha.includes(this.EvaluacionBuscada.fecha) &&
          x.nombre.includes(this.EvaluacionBuscada.nombre) &&
            x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
          String(x.nrespuestas).includes(this.nrespuestas));
      }
    }
    
    return BuscaPersonalizada;
  }

  //Guarda los datos en el storage y cambia de ruta hacia la generación de grafica
  public SaveDataToPDF(evaluacion: EvaluacionInfo) {
    this._appComponent._storageDataService.EvaluacionToPDF = evaluacion;
    this._router.navigate(['/pdfgenerator']);
  }

  //Filtra por evaluaciones completas completas o ninguna
  public ChangeFiltro(estado: boolean) {
    this.FiltrarCompletados = estado;
  }

}
