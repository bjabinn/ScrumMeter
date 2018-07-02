import { Component, OnInit } from '@angular/core';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { EvaluacionFilterInfo } from 'app/Models/EvaluacionFilterInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { EvaluacionService } from '../services/EvaluacionService';
import { Evaluacion } from 'app/Models/Evaluacion';
import { Observable } from 'rxjs/Rx';
import { interval } from 'rxjs/observable/interval';
import { ProyectoService } from 'app/services/ProyectoService';
import { Role } from 'app/Models/Role';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';
import { Subscription } from 'rxjs/Subscription';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';

@Component({
  selector: 'app-previousevaluation',
  templateUrl: './previousevaluation.component.html',
  styleUrls: ['./previousevaluation.component.scss'],
  providers: [EvaluacionService, ProyectoService]
})
export class PreviousevaluationComponent implements OnInit {
  public clicked: boolean = true;
  public EvaluacionFiltrar: EvaluacionFilterInfo = { 'nombre': '', 'estado': '', 'fecha': '', 'userNombre': '', 'puntuacion': ''};
  public Typing: boolean = false;
  public permisosDeUsuario: Array<Role> = [];
  public ListaDeEvaluacionesPaginada: Array<EvaluacionInfo>;
  public nEvaluaciones: number = 0;
  public UserName: string = "";
  public Project: Proyecto = { 'id': null, 'nombre': '', 'fecha': null };
  public Mostrar = false;
  public PageNow = 1;
  public NumMax = 0;
  public ErrorMessage: string = null;
  public NumEspera = 750;
  public MostrarInfo = false;
  public Timeout: Subscription;
  public textoModal: string;
  public anadeNota = null;
  public fechaPicker: NgbDate;

  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    private _evaluacionService: EvaluacionService,
    private _proyectoService: ProyectoService,
    private modalService: NgbModal) { }

  ngOnInit() {
    //Recogemos los proyectos y realizamos comprobaciones
    var Role;
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }
    this.UserName = this._proyectoService.UsuarioLogeado;

    //Recogemos el rol del usuario
    this._proyectoService.getRolesUsuario().subscribe(
      res => {

        this.permisosDeUsuario = res;
        var Admin = false;
        //Si no hay errores y son recogidos busca si tienes permisos de usuario
        for (let num = 0; num < this.permisosDeUsuario.length; num++) {
          if (this.permisosDeUsuario[num].role == "Administrador") {
            if (this.Project == null || this.Project == undefined || this.Project.id == -1) {
              this.Project = { id: 0, nombre: '', fecha: null };
              Admin = true;
            }
          }
        }

        //Comprueba que tenga  un proyecto seleccionado y si no es asi lo devuelve a home
        if (this.Project == null || this.Project == undefined) {
          this._router.navigate(['/home']);
        } else if (this.Project.id == -1 && !Admin) {
          this._router.navigate(['/home']);
        } else {
          this.MostrarInfo = true;
        }

        this.GetPaginacion();

      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: ", error, "No pudimos recoger los datos del usuario.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: ", error, " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      },
      () => {
        this.Restablecer();
      });

    if (this.Project.fecha != null) {
      this._appComponent.anadirUserProyecto(this.UserName, this.Project.nombre);
    } else {
      this._appComponent.anadirUserProyecto(this.UserName, "Todos");
    }
  }

  //Este metodo devuelve el número de paginas máximo que hay
  public CalcularPaginas() {
    var NumeroDePaginas = Math.floor((this.nEvaluaciones / 10) * 100) / 100;
    if (NumeroDePaginas % 1 != 0) {
      this.NumMax = Math.floor(NumeroDePaginas) + 1;
    } else {
      this.NumMax = NumeroDePaginas;
    }
  }

  //Restablece los datos de la busqueda
  public Restablecer() {
    if (this.clicked) {
      this.EvaluacionFiltrar.fecha = "";
      this.EvaluacionFiltrar.nombre = "";
      this.EvaluacionFiltrar.userNombre = "";
      this.EvaluacionFiltrar.estado = "";
      this.EvaluacionFiltrar.puntuacion = "";
      this.GetPaginacion();
      this.clicked = false;
    } else {
      this.clicked = true;
    }
  }

  //Este metodo devuelve la transforma la lista de evaluaciones dada en una lista paginada
  public paginacionLista(pageNumber: number) {
    var Skip = pageNumber * 10;
    var ListaPaginada = new Array<EvaluacionInfo>();
    var contador = Skip;
    while (ListaPaginada.length != 10 && contador < this.ListaDeEvaluacionesPaginada.length) {
      ListaPaginada.push(this.ListaDeEvaluacionesPaginada[contador]);
      contador++;
    }
    this.ListaDeEvaluacionesPaginada = ListaPaginada;
  }

  //Utiliza los datos del filtrado para realizar un filtrado en el array
  /* public Busqueda() {
     var BuscaPersonalizada: Array<EvaluacionInfo> = this.ListaDeEvaluacionesPaginada;
     this.CalcularPaginas();
     //Si no filtra por completos o incompletos
     if (this.FiltrarCompletados == null) {
       BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
         x => x.fecha.includes(this.ListaDeEvaluacionesPaginada.fecha) &&
           x.nombre.includes(this.ListaDeEvaluacionesPaginada.nombre) &&
           x.userNombre.includes(this.ListaDeEvaluacionesPaginada.userNombre) &&
           String(x.nRespuestas).includes(this.nrespuestas));
     } else {
       //Filtrando por completos
       if (this.FiltrarCompletados) {
         BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
           x => x.estado &&
             x.fecha.includes(this.ListaDeEvaluacionesPaginada.fecha) &&
             x.nombre.includes(this.ListaDeEvaluacionesPaginada.nombre) &&
             x.userNombre.includes(this.ListaDeEvaluacionesPaginada.userNombre) &&
             String(x.nRespuestas).includes(this.nrespuestas));
       } else {
         //Filtrando por incompletos
         BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
           x => x.estado == false &&
             x.fecha.includes(this.ListaDeEvaluacionesPaginada.fecha) &&
             x.nombre.includes(this.ListaDeEvaluacionesPaginada.nombre) &&
             x.userNombre.includes(this.ListaDeEvaluacionesPaginada.userNombre) &&
             String(x.nRespuestas).includes(this.nrespuestas));
       }
     }
     return BuscaPersonalizada;
   }*/

  //Guarda los datos en el storage y cambia de ruta hacia la generación de grafica
  public SaveDataToPDF(evaluacion: EvaluacionInfo) {
    this._appComponent._storageDataService.EvaluacionToPDF = evaluacion;
    this._router.navigate(['/pdfgenerator']);
  }

  //Filtra por evaluaciones completas completas o ninguna
  public ChangeFiltro(estado: string) {
    this.PageNow = 1;
    this.EvaluacionFiltrar.estado = estado;
    this.GetPaginacion();
  }

  //Al presionar el boton va avanzado y retrocediendo
  public NextPreviousButton(Option: boolean) {
    if (Option && this.PageNow < this.NumMax) {
      this.paginacionLista(this.PageNow++);
      this.GetPaginacion();
    } else if (!Option && this.PageNow > 1) {
      this.PageNow--;
      var CualToca = this.PageNow - 1;
      this.paginacionLista(CualToca);
      this.GetPaginacion();
    }
  }

  //Este metodo es llamado cuando cambias un valor de filtrado y en 750 milisegundos te manda a la primera pagina y recarga el componente con
  //los nuevos elementos
  public TryHttpRequest() {
    if (this.Timeout != null && !this.Timeout != undefined) {
      this.Timeout.unsubscribe();
    }
    this.Timeout = Observable.interval(750)
      .subscribe(i => {
        this.PageNow = 1, this.GetPaginacion(),
          this.Timeout.unsubscribe()
      });
  }

  //Recarga los elementos en la pagina en la que se encuentra 
  public GetPaginacion() {
    this.Mostrar = false;
    this._evaluacionService.getEvaluacionInfoFiltered(this.PageNow - 1, this.Project.id, this.EvaluacionFiltrar)
      .subscribe(
      res => {
        this.nEvaluaciones = res.numEvals;
        this.ListaDeEvaluacionesPaginada = res.evaluacionesResult;
        this.CalcularPaginas();
        this.Mostrar = true;
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: ", error, " No pudimos recoger la información de las evaluaciones, lo sentimos.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: ", error, " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });

  }

  //tipo=0 -> Evaluacion
  //tipo=1 -> Objetivos
  public AbrirModal(content, numeroEv, tipo) {

    this.anadeNota = null;

    if (tipo == 0) {
      if (this.ListaDeEvaluacionesPaginada[numeroEv].notasEv != null) {
        this.textoModal = this.ListaDeEvaluacionesPaginada[numeroEv].notasEv;
      } else {
        this.textoModal = "";
      }
    } else if (tipo == 1) {
      if (this.ListaDeEvaluacionesPaginada[numeroEv].notasOb != null) {
        this.textoModal = this.ListaDeEvaluacionesPaginada[numeroEv].notasOb;
      } else {
        this.textoModal = "";
      }
    }

    this.modalService.open(content).result.then(
      (closeResult) => {
        //Si cierra, no se guarda
        
      }, (dismissReason) => {
        if (dismissReason == 'Guardar') {

          this.Mostrar = false;

          if (tipo == 0) {
            if (this.textoModal != "") {
              this.ListaDeEvaluacionesPaginada[numeroEv].notasEv = this.textoModal;
            } else {
              this.ListaDeEvaluacionesPaginada[numeroEv].notasEv = null;
            }
          } else {
            if (this.textoModal != "") {
              this.ListaDeEvaluacionesPaginada[numeroEv].notasOb = this.textoModal;
            } else {
              this.ListaDeEvaluacionesPaginada[numeroEv].notasOb = null;
            }
          }

          var evalu = new Evaluacion(
            this.ListaDeEvaluacionesPaginada[numeroEv].id,
            this.ListaDeEvaluacionesPaginada[numeroEv].fecha,
            this.ListaDeEvaluacionesPaginada[numeroEv].estado,
            this.ListaDeEvaluacionesPaginada[numeroEv].notasOb,
            this.ListaDeEvaluacionesPaginada[numeroEv].notasEv
          );

          this._evaluacionService.updateEvaluacion(evalu)
            .subscribe(
            res => {
                this.anadeNota = "Se guardó la nota correctamente";
              },
              error => {
                if (error == 404) {
                  this.ErrorMessage = "Error: ", error, " No pudimos recoger la información de las evaluaciones, lo sentimos.";
                } else if (error == 500) {
                  this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
                } else if (error == 401) {
                  this.ErrorMessage = "Error: ", error, " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
                } else {
                  this.ErrorMessage = "Error: ", error, " Ocurrio un error en el servidor, contacte con el servicio técnico.";
                }
            },
            () => {
              this.Mostrar = true;
            });


        }
          //Else, Click fuera, no se guarda
      })
  }

  public VolverInicio() {
    this._router.navigate(['/home']);
  }

  public changeDate() {
    if (this.fechaPicker.day < 10) {
      this.EvaluacionFiltrar.fecha = "0" + this.fechaPicker.day + "/";
    } else {
      this.EvaluacionFiltrar.fecha = this.fechaPicker.day + "/";
    }

    if (this.fechaPicker.month < 10) {
      this.EvaluacionFiltrar.fecha = this.EvaluacionFiltrar.fecha + "0" + this.fechaPicker.month + "/" + this.fechaPicker.year;
    } else {
      this.EvaluacionFiltrar.fecha = this.EvaluacionFiltrar.fecha + this.fechaPicker.month + "/" + this.fechaPicker.year;
    }

    this.PageNow = 1;
    this.GetPaginacion();

  }

  public limpiar() {
    this.EvaluacionFiltrar.fecha = "";

    this.PageNow = 1;
    this.GetPaginacion();
  }

}
