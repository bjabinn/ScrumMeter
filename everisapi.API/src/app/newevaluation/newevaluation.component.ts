import { Component, OnInit } from '@angular/core';
import { EvaluacionService } from '../services/EvaluacionService';
import { RespuestasService } from '../services/RespuestasService';
import { AppComponent } from '../app.component';
import { Asignacion } from './Asignacion';
import { Pregunta } from './Pregunta';
import { Respuesta } from './Respuesta';

@Component({
  selector: 'app-newevaluation',
  templateUrl: './newevaluation.component.html',
  styleUrls: ['./newevaluation.component.scss'],
  providers: [EvaluacionService, RespuestasService]
})
export class NewevaluationComponent implements OnInit {
  ListaAsignaciones: Array<Asignacion> = [];
  ListaPreguntas: Array<Pregunta> = [];
  ListaRespuestas: Array<Respuesta> = [];
  NumMax: number = 0;
  PageNow: number = 1;
  idProyect: number = 0;
  AreaAsignada: Asignacion = { 'id': 0, 'nombre': "undefined" };

  constructor(
    private _evaluacionService: EvaluacionService,
    private _respuestasService: RespuestasService,
    private _appComponent: AppComponent) {

    var idSelected = this._appComponent._storageDataService.IdSection;
    this.idProyect = this._appComponent._storageDataService.UserProjectSelected.id;
    console.log("Seleccionaste la id de section: " + idSelected)
    this._evaluacionService.getAsignacionesSection(idSelected).subscribe(
      res => {
        if (res != null) {
          this.ListaAsignaciones = res;
          this.NumMax = this.ListaAsignaciones.length;
          console.log("Asignaciones: ", this.ListaAsignaciones);
          this.AreaAsignada = this.ListaAsignaciones[0];
          this.getQuestions(this.ListaAsignaciones[0].id);
          this.getAnswers(this.idProyect, this.AreaAsignada.id);
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

  public getQuestions(id: number) {
    this._evaluacionService.getPreguntasSection(id).subscribe(
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

  public getAnswers(idProyecto: number, idAsignacion: number) {
    console.log("intentado para respuestas con id pro: ", idProyecto, "idAsignacion: ", idAsignacion)
    this._respuestasService.getRespuestasAsigProy(idProyecto, idAsignacion).subscribe(
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

  public ChangeEstadoDB(idarray: number) {
    var idRespuesta = this.ListaRespuestas[idarray].id;
    if (this.ListaRespuestas[idarray].estado) {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, false);
    } else {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, true);
    }
  }

  public NextPreviousButton(Option: boolean) {
    if (Option && this.PageNow < this.NumMax) {
      this.getQuestions(this.ListaAsignaciones[this.PageNow].id);
      this.AreaAsignada = this.ListaAsignaciones[this.PageNow];
      this.getAnswers(this.idProyect, this.AreaAsignada.id);
      this.PageNow++;
    } else if ( this.PageNow > 1) {
      this.PageNow--;
      var CualToca = this.PageNow - 1;
      this.AreaAsignada = this.ListaAsignaciones[CualToca];
      this.getQuestions(this.ListaAsignaciones[CualToca].id);
      this.getAnswers(this.idProyect, this.AreaAsignada.id);
    }
  }
}
