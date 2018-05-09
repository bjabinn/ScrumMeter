import { Component, OnInit } from '@angular/core';
import { SectionService } from '../services/SectionService';
import { RespuestasService } from '../services/RespuestasService';
import { AppComponent } from '../app.component';
import { Asignacion } from 'app/Models/Asignacion';
import { Pregunta } from 'app/Models/Pregunta';
import { Proyecto } from 'app/Models/Proyecto';
import { Respuesta } from 'app/Models/Respuesta';
import { Router } from "@angular/router";
import { Evaluacion } from 'app/Models/Evaluacion';
import { LoadingComponent } from '../loading/loading.component';

@Component({
  selector: 'app-newevaluation',
  templateUrl: './newevaluation.component.html',
  styleUrls: ['./newevaluation.component.scss'],
  providers: [SectionService, RespuestasService]
})
export class NewevaluationComponent implements OnInit {
  ListaAsignaciones: Array<Asignacion> = [];
  ListaPreguntas: Array<Pregunta> = [];
  ListaRespuestas: Array<Respuesta> = [];
  NumMax: number = 0;
  PageNow: number = 1;
  Project: Proyecto = null;
  Evaluation: Evaluacion = null;
  AreaAsignada: Asignacion = { 'id': 0, 'nombre': "undefined" };
  UserName: string = "";

  //Recogemos todos los datos de la primera area segun su id y las colocamos en la lista
  constructor(
    private _sectionService: SectionService,
    private _respuestasService: RespuestasService,
    private _router: Router,
    private _appComponent: AppComponent) {

    var idSelected = this._appComponent._storageDataService.IdSection;
    //Recogemos el proyecto y el usuario si no coincide alguno lo redirigiremos
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    this.Evaluation = this._appComponent._storageDataService.Evaluacion;

    if (this._appComponent._storageDataService.UserData == undefined || this._appComponent._storageDataService.UserData == null) {
      this.UserName = localStorage.getItem("user");
      if (this.UserName == undefined || this.UserName == null || this.UserName == "") {
        this._router.navigate(['/login']);
      }
      if (this.Project == null || this.Project == undefined || this.Evaluation == null || this.Evaluation == undefined) {
        this._router.navigate(['/home']);
      }
    } else {
      this.UserName = this._appComponent._storageDataService.UserData.nombre;
    }

    console.log("Seleccionaste la id de section: " + idSelected)
    this._sectionService.getAsignacionesSection(idSelected).subscribe(
      res => {
        if (res != null) {
          this.ListaAsignaciones = res;
          this.NumMax = this.ListaAsignaciones.length;
          console.log("Asignaciones: ", this.ListaAsignaciones);
          this.AreaAsignada = this.ListaAsignaciones[0];
          this.getQuestions(this.ListaAsignaciones[0].id);
          this.getAnswers(this.Evaluation.id, this.AreaAsignada.id);
        } else {
          console.log("Esto esta muy vacio");
        }
      },
      error => {
        console.log("error lista asignaciones");
      }
    );

  }

  ngOnInit() {

  }

  //Recoge todas las preguntas
  public getQuestions(id: number) {
    console.log("investigar questions id:", id);
    this._sectionService.getPreguntasArea(id).subscribe(
      res => {
        if (res != null) {
          this.ListaPreguntas = res;
          console.log("Preguntas: ", this.ListaPreguntas);
        } else {
          console.log("Esto esta muy vacio");
        }
      },
      error => {
        console.log("error lista Preguntas");
      }
    );
  }

  //Recoge todas las respuestas
  public getAnswers(idEvaluacion: number, idAsignacion: number) {
    console.log("investigar answer: ", idEvaluacion, " Asignacion: ", idAsignacion);
    this._respuestasService.getRespuestasAsigProy(idEvaluacion, idAsignacion).subscribe(
      res => {
        if (res != null) {
          this.ListaRespuestas = res;
          console.log("Respuestas: ", this.ListaRespuestas);
        } else {
          console.log("Esto esta muy vacio");
        }
      },
      error => {
        console.log("error lista Respuestas");
      }
    );
  }

  //Cambia el estado de las preguntas
  public ChangeEstadoDB(idarray: number) {
    var idRespuesta = this.ListaRespuestas[idarray].id;
    if (this.ListaRespuestas[idarray].estado) {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, false).subscribe(
        res => {
          console.log("Cambio realizado");
        },
        error => {
          console.log("Cambio fallido ", error);
        });
      this.ListaRespuestas[idarray].estado = false;
    } else {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, true).subscribe(
        res => {
          console.log("Cambio realizado");
        },
        error => {
          console.log("Cambio fallido ", error);
        });
      this.ListaRespuestas[idarray].estado = true;
    }
  }

  //Al presionar el boton va avanzado y retrocediendo
  public NextPreviousButton(Option: boolean) {
    if (Option && this.PageNow < this.NumMax) {
      this.getQuestions(this.ListaAsignaciones[this.PageNow].id);
      this.AreaAsignada = this.ListaAsignaciones[this.PageNow];
      this.getAnswers(this.Evaluation.id, this.AreaAsignada.id);
      this.PageNow++;
    } else if (!Option && this.PageNow > 1) {
      this.PageNow--;
      var CualToca = this.PageNow - 1;
      this.AreaAsignada = this.ListaAsignaciones[CualToca];
      this.getQuestions(this.ListaAsignaciones[CualToca].id);
      this.getAnswers(this.Evaluation.id, this.AreaAsignada.id);
    } else if (Option && this.PageNow == this.NumMax) {
      this._router.navigate(['/menunuevaevaluacion']);
    }
  }
}
