import { Component, OnInit } from '@angular/core';
import { SectionService } from '../services/SectionService';
import { RespuestasService } from '../services/RespuestasService';
import { AppComponent } from '../app.component';
import { Asignacion } from 'app/Models/Asignacion';
import { Pregunta } from 'app/Models/Pregunta';
import { Proyecto } from 'app/Models/Proyecto';
import { Respuesta } from 'app/Models/Respuesta';
import { AsignacionInfo } from 'app/Models/AsignacionInfo';
import { Router } from "@angular/router";
import { Evaluacion } from 'app/Models/Evaluacion';
import { Section } from 'app/Models/Section';

@Component({
  selector: 'app-newevaluation',
  templateUrl: './newevaluation.component.html',
  styleUrls: ['./newevaluation.component.scss'],
  providers: [SectionService, RespuestasService]
})
export class NewevaluationComponent implements OnInit {
  public ListaAsignaciones: Array<Asignacion> = [];
  public InfoAsignacion: AsignacionInfo = { id: null, nombre: '', preguntas: null };
  public NumMax: number = 0;
  public PageNow: number = 1;
  public Project: Proyecto = null;
  public Evaluation: Evaluacion = null;
  public AreaAsignada: Asignacion = { 'id': 0, 'nombre': "undefined" };
  public UserName: string = "";
  public SectionSelected: Section = null;
  public Deshabilitar = true;
  public ErrorMessage: string = null;
  public MostrarInfo = false;

  //Recogemos todos los datos de la primera area segun su id y las colocamos en la lista
  constructor(
    private _sectionService: SectionService,
    private _respuestasService: RespuestasService,
    private _router: Router,
    private _appComponent: AppComponent) {

    this.SectionSelected = this._appComponent._storageDataService.SectionSelected;
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

    this.MostrarInfo = true;

    //Recoge todas las asignaciones de la section por id
    if (this.Evaluation != null && this.Evaluation != undefined && this.SectionSelected != null && this.SectionSelected != undefined) {
      this._sectionService.getAsignacionesSection(this.SectionSelected.id).subscribe(
        res => {
          if (res != null) {
            this.ListaAsignaciones = res;
            this.NumMax = this.ListaAsignaciones.length;
            this.getAsignacionActual(this.Evaluation.id, this.ListaAsignaciones[0].id);
            this.Deshabilitar = false;
          } else {
            //console.log("Esto esta muy vacio");
          }
        },
        error => {
          this.ErrorMessage = "Error en la base de datos, " + error;
        }
      );
    } else {
      this._router.navigate(['/home']);
    }
  }

  ngOnInit() {

  }

  //Le proporciona a la asignación en la que nos encontramos todos los datos
  public getAsignacionActual(idSelected, idAsignacion) {
    this._respuestasService.getRespuestasAsig(idSelected, idAsignacion).subscribe(
      res => {
        if (res != null) {
          this.InfoAsignacion = res;
          this.Deshabilitar = false;
        } else {
          console.log("Esto esta muy vacio");
        }
      },
      error => {
        this.ErrorMessage = "Error en la base de datos, " + error;
      }
    );
  }

  //Cambia el estado de las preguntas
  public ChangeEstadoDB(idarray: number) {
    var Respuesta;
    if (this.InfoAsignacion.preguntas[idarray].respuesta.estado) {
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = false;
      Respuesta = this.InfoAsignacion.preguntas[idarray].respuesta;
      this._respuestasService.AlterEstadoRespuesta(Respuesta).subscribe(
        res => {
          //console.log("Cambio realizado");
        },
        error => {
          this.ErrorMessage = "Error en la base de datos, " + error;
        });
    } else {
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = true;
      Respuesta = this.InfoAsignacion.preguntas[idarray].respuesta;
      this._respuestasService.AlterEstadoRespuesta(Respuesta).subscribe(
        res => {
          //console.log("Cambio realizado");
        },
        error => {
          this.ErrorMessage = "Error en la base de datos, " + error;
        });
    }
  }

  //Al presionar el boton va avanzado y retrocediendo
  public NextPreviousButton(Option: boolean) {
    if (Option && this.PageNow < this.NumMax) {
      this.Deshabilitar = true;
      this.AreaAsignada = this.ListaAsignaciones[this.PageNow];
      this.getAsignacionActual(this.Evaluation.id, this.AreaAsignada.id);
      this.PageNow++;
    } else if (!Option && this.PageNow > 1) {
      this.PageNow--;
      this.Deshabilitar = true;
      var CualToca = this.PageNow - 1;
      this.AreaAsignada = this.ListaAsignaciones[CualToca];
      this.getAsignacionActual(this.Evaluation.id, this.AreaAsignada.id);
    } else if (Option && this.PageNow == this.NumMax) {
      this._router.navigate(['/menunuevaevaluacion']);
    }
  }
}
