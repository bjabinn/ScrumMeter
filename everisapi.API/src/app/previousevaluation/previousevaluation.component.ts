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
import { Subscription } from 'rxjs/Subscription';

@Component({
  selector: 'app-previousevaluation',
  templateUrl: './previousevaluation.component.html',
  styleUrls: ['./previousevaluation.component.scss'],
  providers: [EvaluacionService, ProyectoService]
})
export class PreviousevaluationComponent implements OnInit {
  public clicked: boolean = true;
  public EvaluacionFiltrar: EvaluacionFilterInfo = { 'nombre': '', 'estado': '', 'fecha': '', 'userNombre': '', 'nPreguntas': '', 'nRespuestas': '' };
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


  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    private _evaluacionService: EvaluacionService,
    private _proyectoService: ProyectoService) { }

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
          this.ErrorMessage = "El usuario actual no fue encontrado en nuestro servidor.";
        } else if (error == 500) {
          this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });
    //Recoge la información extendida necesaria para la lista de evaluaciones
    /* this._evaluacionService.getEvaluacionInfo(this.Project.id).subscribe(
       res => {
         this.ListaDeEvaluaciones = res;
         this.CalcularPaginas();
         this.paginacionLista(0);
         this.Mostrar = true;
       },
       error => {
          this.ErrorMessage = "Error en la base de datos, " + error;
       });*/
  }

  //Este metodo devuelve el número de paginas máximo que hay
  public CalcularPaginas() {
    var NumeroDePaginas = Math.floor((this.nEvaluaciones / 5) * 100) / 100;
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
      this.EvaluacionFiltrar.nPreguntas = "";
      this.EvaluacionFiltrar.nRespuestas = "";
      this.EvaluacionFiltrar.estado = "";
      this.EvaluacionFiltrar.nRespuestas = "";
      this.GetPaginacion();
      this.clicked = false;
    } else {
      this.clicked = true;
    }
  }

  //Este metodo devuelve la transforma la lista de evaluaciones dada en una lista paginada
  public paginacionLista(pageNumber: number) {
    var Skip = pageNumber * 5;
    var ListaPaginada = new Array<EvaluacionInfo>();
    var contador = Skip;
    while (ListaPaginada.length != 5 && contador < this.ListaDeEvaluacionesPaginada.length) {
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
        this.ErrorMessage = "Error en la base de datos, " + error;
      });

  }

}
