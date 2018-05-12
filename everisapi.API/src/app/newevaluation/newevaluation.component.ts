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
import { LoadingComponent } from '../loading/loading.component';

@Component({
  selector: 'app-newevaluation',
  templateUrl: './newevaluation.component.html',
  styleUrls: ['./newevaluation.component.scss'],
  providers: [SectionService, RespuestasService]
})
export class NewevaluationComponent implements OnInit {
  private ListaAsignaciones: Array<Asignacion> = [];
  private InfoAsignacion: AsignacionInfo = { id: null, nombre: '', preguntas: null };
  private NumMax: number = 0;
  private PageNow: number = 1;
  private Project: Proyecto = null;
  private Evaluation: Evaluacion = null;
  private AreaAsignada: Asignacion = { 'id': 0, 'nombre': "undefined" };
  private UserName: string = "";
  private idSelected = 0;
  private Deshabilitar = false;

  //Recogemos todos los datos de la primera area segun su id y las colocamos en la lista
  constructor(
    private _sectionService: SectionService,
    private _respuestasService: RespuestasService,
    private _router: Router,
    private _appComponent: AppComponent) {

    this.idSelected = this._appComponent._storageDataService.IdSection;
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

    this._sectionService.getAsignacionesSection(this.idSelected).subscribe(
      res => {
        if (res != null) {
          this.ListaAsignaciones = res;
          this.NumMax = this.ListaAsignaciones.length;
          this.getAsignacionActual(this.Evaluation.id, this.ListaAsignaciones[0].id);
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
        console.log("error lista asignaciones");
      }
    );
  }

  //Cambia el estado de las preguntas
  public ChangeEstadoDB(idarray: number) {
    var idRespuesta = this.InfoAsignacion.preguntas[idarray].respuesta.id;
    if (this.InfoAsignacion.preguntas[idarray].respuesta.estado) {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, false).subscribe(
        res => {
          //console.log("Cambio realizado");
        },
        error => {
          console.log("Cambio fallido ", error);
        });
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = false;
    } else {
      this._respuestasService.AlterEstadoRespuesta(idRespuesta, true).subscribe(
        res => {
          //console.log("Cambio realizado");
        },
        error => {
          console.log("Cambio fallido ", error);
        });
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = true;
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
