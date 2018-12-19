import { Component, OnInit } from '@angular/core';
import { SectionService } from '../services/SectionService';
import { RespuestasService } from '../services/RespuestasService';
import { AppComponent } from '../app.component';
import { Asignacion } from 'app/Models/Asignacion';
import { Pregunta } from 'app/Models/Pregunta';
import { Proyecto } from 'app/Models/Proyecto';
import { Respuesta } from 'app/Models/Respuesta';
import { AsignacionInfo } from 'app/Models/AsignacionInfo';
import { AsignacionUpdate } from 'app/Models/AsignacionUpdate';
import { Router } from "@angular/router";
import { Evaluacion } from 'app/Models/Evaluacion';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';
import { Section } from 'app/Models/Section';
import { SectionInfo } from 'app/Models/SectionInfo';
import { SectionModify } from 'app/Models/SectionModify';
import { ProyectoService } from 'app/services/ProyectoService';
import { EvaluacionService } from 'app/services/EvaluacionService';

@Component({
  selector: 'app-newevaluation',
  templateUrl: './newevaluation.component.html',
  styleUrls: ['./newevaluation.component.scss'],
  providers: [SectionService, RespuestasService, ProyectoService, EvaluacionService]
})
export class NewevaluationComponent implements OnInit {
  public ListaAsignaciones: Array<Asignacion> = [];
  public InfoAsignacion: AsignacionInfo = { id: null, nombre: '', preguntas: null, 'notas': null };
  public NumMax: number = 0;
  public PageNow: number = 1;
  public Project: Proyecto = null;
  public Evaluation: Evaluacion = null;
  public AreaAsignada: Asignacion = { 'id': 0, 'nombre': "undefined" };
  public UserName: string = "";
  public SectionSelected: SectionInfo = null;
  public Deshabilitar = true;
  public ErrorMessage: string = null;
  public MostrarInfo = false;
  public textoModal: string;
  public anadeNota: string = null;
  public pagesArray: number[];
  public nextSection: SectionInfo = null;

  //Recogemos todos los datos de la primera area segun su id y las colocamos en la lista
  constructor(
    private _sectionService: SectionService,
    private _respuestasService: RespuestasService,
    private _router: Router,
    private _appComponent: AppComponent,
    private modalService: NgbModal,
    private _proyectoService: ProyectoService) {

        this.InitialiseComponent();

  }

  ngOnInit() {

    this.Evaluation = this._appComponent._storageDataService.Evaluacion;
  }
  
  private InitialiseComponent(){
    
    this.PageNow = 1;
    this.SectionSelected = this._appComponent._storageDataService.SectionSelectedInfo;
    this.nextSection = this._appComponent._storageDataService.nextSection;
    //Recogemos el proyecto y el usuario si no coincide alguno lo redirigiremos
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    this.Evaluation = this._appComponent._storageDataService.Evaluacion;
    this._proyectoService.verificarUsuario();
    if (this._appComponent._storageDataService.UserData == undefined || this._appComponent._storageDataService.UserData == null) {
      this.UserName = this._proyectoService.UsuarioLogeado;
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

            let i = 0;
            this.pagesArray = [];

            // console.log(this.NumMax);


            while (this.NumMax > i) {
              i++;

              this.pagesArray.push(i);
              // console.log(this.pagesArray[i]);

            }


            this.getAsignacionActual(this.Evaluation.id, this.ListaAsignaciones[0].id);
            this.Deshabilitar = false;
          } else {
            this.ErrorMessage = "No se encontraron datos para esta sección.";
          }
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: " + error + " No se pudo acceder a la información de esta evaluación.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        }
      );
    } else {
      this._router.navigate(['/home']);
    }


    // this.pagesArray = [1,2,3,4,5];
  }

  //Le proporciona a la asignación en la que nos encontramos todos los datos
  public getAsignacionActual(idSelected, idAsignacion) {
    this._respuestasService.getRespuestasAsig(idSelected, idAsignacion).subscribe(
      res => {
        if (res != null) {
          this.InfoAsignacion = res;

          this.Deshabilitar = false;
        } else {
          this.ErrorMessage = "No se encontraron datos para esta asignación.";
        }
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + "No se pudo acceder a los datos de esta asignación.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }
    );
  }

  public redirectToNextSection() {
    this._appComponent._storageDataService.SectionSelectedInfo = this.nextSection;
    
    let index = this._appComponent._storageDataService.Sections.indexOf(this.nextSection);

    this._appComponent._storageDataService.nextSection = (index + 1) != this._appComponent._storageDataService.Sections.length
      ? this._appComponent._storageDataService.Sections[index + 1]
      : null;

    this.InitialiseComponent();
    // this._router.navigate(['/nuevaevaluacion']);

  }

  public AnswerQuestion(pregunta, index, statusToBe) {

    //If the user clicks on the first item and he clicked "NO" just remove all the other answers and make it not answered
    if (index == 0 && statusToBe == 2 && this.InfoAsignacion.preguntas[index].correcta == null) { //correcta == null is to ensure the first question is required to answer the other ones
      this.InfoAsignacion.preguntas[index].respuesta.estado = statusToBe;
      this._respuestasService.updateRespuestasAsig(this.Evaluation.id, this.InfoAsignacion.id).subscribe(
        res => {
          //Respuestas actualizadas correctamente
          for (var i = 1; i < this.InfoAsignacion.preguntas.length; i++) {
            this.InfoAsignacion.preguntas[i].respuesta.estado = 0;
          }
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: " + error + "No se pudo acceder a los datos de esta asignación.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        }
      );
    } else {

      if (statusToBe != pregunta.respuesta.estado) {
        this.InfoAsignacion.preguntas[index].respuesta.estado = statusToBe;
        let respuesta = this.InfoAsignacion.preguntas[index].respuesta;
        this._respuestasService.AlterRespuesta(respuesta).subscribe(
          res => {
          },
          error => {
            if (error == 404) {
              this.ErrorMessage = "Error: " + error + "No pudimos realizar la actualización de la respuesta, lo sentimos.";
            } else if (error == 500) {
              this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
            } else if (error == 401) {
              this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
            } else {
              this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
            }
          });
      }
    }
  }

  //Cambia el estado de las preguntas
  public ChangeEstadoDB(idarray: number) {
    this.anadeNota = null;

    var Respuesta;

    //Cambia el estado
    if (this.InfoAsignacion.preguntas[idarray].respuesta.estado == 1) {
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = 2;
    } else {
      this.InfoAsignacion.preguntas[idarray].respuesta.estado = 1;
    }


    //En caso de que se seleccione el primero, ponemos todos a NC
    if (idarray == 0 && this.InfoAsignacion.preguntas[idarray].respuesta.estado == 2 && this.InfoAsignacion.preguntas[idarray].correcta == null) {
      this._respuestasService.updateRespuestasAsig(this.Evaluation.id, this.InfoAsignacion.id).subscribe(
        res => {
          //Respuestas actualizadas correctamente
          for (var i = 1; i < this.InfoAsignacion.preguntas.length; i++) {
            this.InfoAsignacion.preguntas[i].respuesta.estado = 0;
          }
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: " + error + "No se pudo acceder a los datos de esta asignación.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        }
      );

    } else {

      //Guardamos la respuesta
      Respuesta = this.InfoAsignacion.preguntas[idarray].respuesta;
      this._respuestasService.AlterRespuesta(Respuesta).subscribe(
        res => {
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: " + error + "No pudimos realizar la actualización de la respuesta, lo sentimos.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        });

    }
  }

  //Al presionar el boton va avanzado y retrocediendo
  //0 finalizar
  //1 avanzar
  //2 retroceder
  public NextPreviousButton(Option: number) {
    this.anadeNota = null;
    // console.log("opcion --- ",Option);


    if (Option == 1) {
      this.Deshabilitar = true;
      this.AreaAsignada = this.ListaAsignaciones[this.PageNow];
      this.getAsignacionActual(this.Evaluation.id, this.AreaAsignada.id);
      this.PageNow++;

    } else if (Option == 2) {
      this.PageNow--;
      this.Deshabilitar = true;
      var CualToca = this.PageNow - 1;
      this.AreaAsignada = this.ListaAsignaciones[CualToca];
      this.getAsignacionActual(this.Evaluation.id, this.AreaAsignada.id);

    } else if (Option == 0) {
      this._router.navigate(['/menunuevaevaluacion']);
    }
  }

  //Para abrir las notas de preguntas
  public AbrirModalPreg(content, i) {

    this.anadeNota = null;

    if (this.InfoAsignacion.preguntas[i].respuesta.notas != null) {
      this.textoModal = this.InfoAsignacion.preguntas[i].respuesta.notas;
    } else {
      this.textoModal = "";
    }

    this.modalService.open(content).result.then(
      (closeResult) => {
        //Si cierra, no se guarda

      }, (dismissReason) => {
        if (dismissReason == 'Guardar') {

          this.Deshabilitar = true;

          if (this.textoModal != "") {
            this.InfoAsignacion.preguntas[i].respuesta.notas = this.textoModal;
          } else {
            this.InfoAsignacion.preguntas[i].respuesta.notas = null;
          }


          var Respuesta = this.InfoAsignacion.preguntas[i].respuesta;

          this._respuestasService.AlterRespuesta(Respuesta).subscribe(
            res => {

              this.anadeNota = "Nota añadida correctamente";
              setTimeout(() => { this.anadeNota = null }, 2000);
            },
            error => {

              if (error == 404) {
                this.ErrorMessage = "Error: " + error + "No pudimos realizar la actualización de la respuesta, lo sentimos.";
              } else if (error == 500) {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              } else if (error == 401) {
                this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
              } else {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              }
            },
            () => {
              this.Deshabilitar = false;

            });



        }
        //Else, Click fuera, no se guarda
      })
  }

  //Para abrir las notas de asignaciones
  public AbrirModalAsig(content) {

    this.anadeNota = null;

    if (this.InfoAsignacion.notas != null) {
      this.textoModal = this.InfoAsignacion.notas;
    } else {
      this.textoModal = "";
    }

    this.modalService.open(content).result.then(
      (closeResult) => {
        //Si cierra, no se guarda

      }, (dismissReason) => {
        if (dismissReason == 'Guardar') {

          this.Deshabilitar = true;

          if (this.textoModal != "") {
            this.InfoAsignacion.notas = this.textoModal;
          } else {
            this.InfoAsignacion.notas = null;
          }

          var asig = new AsignacionUpdate(this.Evaluation.id, this.InfoAsignacion.id, this.InfoAsignacion.notas);


          this._respuestasService.AddNotaAsig(asig).subscribe(
            res => {

              this.anadeNota = "Nota añadida correctamente";
              setTimeout(() => { this.anadeNota = null }, 2000);
            },
            error => {

              if (error == 404) {
                this.ErrorMessage = "Error: " + error + "No pudimos realizar la actualización de la respuesta, lo sentimos.";
              } else if (error == 500) {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              } else if (error == 401) {
                this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
              } else {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              }
            },
            () => {
              this.Deshabilitar = false;

            });



        }
        //Else, Click fuera, no se guarda
      })
  }

  //Para abrir las notas de secciones
  public AbrirModalSec(content) {

    this.anadeNota = null;

    if (this.SectionSelected.notas != null) {
      this.textoModal = this.SectionSelected.notas;
    } else {
      this.textoModal = "";
    }

    this.modalService.open(content).result.then(
      (closeResult) => {
        //Si cierra, no se guarda

      }, (dismissReason) => {
        if (dismissReason == 'Guardar') {

          this.Deshabilitar = true;

          if (this.textoModal != "") {
            this.SectionSelected.notas = this.textoModal;
          } else {
            this.SectionSelected.notas = null;
          }


          var SeccionModificada = new SectionModify(this.Evaluation.id, this.SectionSelected.id, this.SectionSelected.notas);

          this._sectionService.addNota(SeccionModificada).subscribe(
            res => {

              this.anadeNota = "Nota añadida correctamente";
              setTimeout(() => { this.anadeNota = null }, 2000);
            },
            error => {

              if (error == 404) {
                this.ErrorMessage = "Error: " + error + "No pudimos realizar la actualización de la respuesta, lo sentimos.";
              } else if (error == 500) {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              } else if (error == 401) {
                this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
              } else {
                this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
              }
            },
            () => {
              this.Deshabilitar = false;

            });

        }
        //Else, Click fuera, no se guarda
      })
  }
}
