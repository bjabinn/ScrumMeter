import { Component, OnInit } from '@angular/core';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { EvaluacionService } from '../services/EvaluacionService';
import { Evaluacion } from 'app/Models/Evaluacion';
import { toInteger } from '@ng-bootstrap/ng-bootstrap/util/util';

@Component({
  selector: 'app-previousevaluation',
  templateUrl: './previousevaluation.component.html',
  styleUrls: ['./previousevaluation.component.scss'],
  providers: [EvaluacionService]
})
export class PreviousevaluationComponent implements OnInit {
  public clicked: boolean = true;
  public EvaluacionBuscada: EvaluacionInfo =
    { 'id': null, 'nombre': '', 'estado': null, 'fecha': '', 'userNombre': null, 'nPreguntas': null, 'nRespuestas': null };
  public ListaDeEvaluaciones: Array<EvaluacionInfo>;
  public ListaDeEvaluacionesPaginada: Array<EvaluacionInfo>;
  public nrespuestas: string = '';
  public FiltrarCompletados: boolean = null;
  public UserName: string = "";
  public Project: Proyecto = { 'id': null, 'nombre': '', 'fecha': null };
  public Mostrar = false;
  private PageNow = 1;
  private NumMax = 0;
  

  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    private _evaluacionService: EvaluacionService) { }

  ngOnInit() {
    //Inicializar 
    this.Restablecer();

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
        this.CalcularPaginas();
        this.paginacionLista(0);
        this.Mostrar = true;
      },
      error => {
        console.log("Error recoger listado de evaluaciones: "+error)
      });
  }

  //Este metodo devuelve el número de paginas máximo que hay
  public CalcularPaginas() {
    var NumeroDePaginas = Math.floor((this.ListaDeEvaluaciones.length / 5) * 100) / 100;
    if (NumeroDePaginas % 1 != 0) {
      this.NumMax = Math.floor(NumeroDePaginas) + 1;
    } else {
      this.NumMax = NumeroDePaginas;
    }
  }

  //Restablece los datos de la busqueda
  public Restablecer() {
    if (this.clicked) {
      this.EvaluacionBuscada.fecha = "";
      this.EvaluacionBuscada.nombre = "";
      this.EvaluacionBuscada.userNombre = "";
      this.EvaluacionBuscada.nPreguntas = null;
      this.EvaluacionBuscada.nRespuestas = null;
      this.EvaluacionBuscada.estado = null;
      this.nrespuestas = '';
      this.clicked = false;
    } else {
      this.clicked = true;
    }
  }

  //Este metodo devuelve la transforma la lista de evaluaciones dada en una lista paginada
  public paginacionLista( pageNumber: number) {
    var Skip = pageNumber * 5;
    var ListaPaginada = new Array<EvaluacionInfo>();
    var contador = Skip;
    while (ListaPaginada.length != 5 && contador < this.ListaDeEvaluaciones.length) {
      ListaPaginada.push(this.ListaDeEvaluaciones[contador]);
      contador++;
    }
    this.ListaDeEvaluacionesPaginada = ListaPaginada;
  }

  //Utiliza los datos del filtrado para realizar un filtrado en el array
  public Busqueda() {
    var BuscaPersonalizada: Array<EvaluacionInfo> = this.ListaDeEvaluacionesPaginada;
    this.CalcularPaginas();
    //Si no filtra por completos o incompletos
    if (this.FiltrarCompletados == null) {
      BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
        x => x.fecha.includes(this.EvaluacionBuscada.fecha) &&
        x.nombre.includes(this.EvaluacionBuscada.nombre) &&
          x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
          String(x.nRespuestas).includes(this.nrespuestas));
    } else {
      //Filtrando por completos
      if (this.FiltrarCompletados) {
        BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
          x => x.estado &&
          x.fecha.includes(this.EvaluacionBuscada.fecha) &&
          x.nombre.includes(this.EvaluacionBuscada.nombre) &&
            x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
            String(x.nRespuestas).includes(this.nrespuestas));
      } else {
        //Filtrando por incompletos
        BuscaPersonalizada = this.ListaDeEvaluacionesPaginada.filter(
          x => x.estado == false &&
          x.fecha.includes(this.EvaluacionBuscada.fecha) &&
          x.nombre.includes(this.EvaluacionBuscada.nombre) &&
            x.userNombre.includes(this.EvaluacionBuscada.userNombre) &&
            String(x.nRespuestas).includes(this.nrespuestas));
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

  //Al presionar el boton va avanzado y retrocediendo
  public NextPreviousButton(Option: boolean) {
    if (Option && this.PageNow < this.NumMax) {
      this.paginacionLista(this.PageNow++);
    } else if (!Option && this.PageNow > 1) {
      this.PageNow--;
      var CualToca = this.PageNow - 1;
      this.paginacionLista(CualToca);
    }
  }

}
