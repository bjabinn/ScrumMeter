import { Component, OnInit, ViewChild } from '@angular/core';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { EvaluacionFilterInfo } from 'app/Models/EvaluacionFilterInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { AppComponent } from 'app/app.component';
import { Router } from '@angular/router';
import { EvaluacionService } from '../services/EvaluacionService';
import { Evaluacion } from 'app/Models/Evaluacion';
import { Observable } from 'rxjs/Rx';
import { Http } from '@angular/http';
import { map } from 'rxjs/operators';
import { interval ,  Subscription } from 'rxjs';
import { ProyectoService } from 'app/services/ProyectoService';
import { Role } from 'app/Models/Role';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';
import { ChartsModule, BaseChartDirective } from 'ng2-charts/ng2-charts';
import { DatePipe } from '@angular/common';
import { SectionInfo } from 'app/Models/SectionInfo';
import { SectionService } from 'app/services/SectionService';
import { forEach } from '@angular/router/src/utils/collection';
import { SectionsLevel } from 'app/pdfgenerator/pdfgenerator.component';
import { Assessment } from 'app/Models/Assessment';
import { EvaluacionInfoWithProgress } from 'app/Models/EvaluacionInfoWithProgress';


 
export interface AssesmentEv{
  id: number,
  name: string
}
 
@Component({
  selector: 'app-pendingevaluation',
  templateUrl: './pendingevaluation.component.html',
  styleUrls: ['./pendingevaluation.component.scss'],
  providers: [EvaluacionService, ProyectoService, SectionService]
})
export class PendingEvaluationComponent implements OnInit {
  public clicked: boolean = true;
  public EvaluacionFiltrar: EvaluacionFilterInfo = { 'nombre': '', 'estado': 'false', 'fecha': '', 'userNombre': '', 'puntuacion': '', 'assessmentId': 0 };
  public Typing: boolean = false;
  public permisosDeUsuario: Array<Role> = [];
  public ListaDeEvaluacionesPaginada: Array<EvaluacionInfoWithProgress>;
  public nEvaluaciones: number = 0;
  public UserName: string = "";
  public Project: Proyecto = { 'id': null, 'nombre': '', 'fecha': null, numFinishedEvals:0, numPendingEvals: 0};
  public Mostrar = false;
  public ErrorMessage: string = null;
  public NumEspera = 750;
  public MostrarInfo = false;
  public Timeout: Subscription;
  public textoModal: string;
  public anadeNota = null;
  public fechaPicker: NgbDate;
  public MostrarTabla: boolean = true;
  public MostrarGrafica: boolean = false;
  

  public Admin: boolean = false;
  public ListaDeProyectos: Array<Proyecto> = [];
  public ProyectoSeleccionado: boolean = false;


  //Para actualizar la grafica
  @ViewChild(BaseChartDirective) public chart: BaseChartDirective;


  constructor(
    private _appComponent: AppComponent,
    private _router: Router,
    public _evaluacionService: EvaluacionService,
    private _proyectoService: ProyectoService,
    private _sectionService: SectionService,
    private modalService: NgbModal,
    private http: Http
  ) { }

  ngOnInit() {
    //Recogemos los proyectos y realizamos comprobaciones
    var Role;
    this.Project = this._appComponent._storageDataService.UserProjectSelected;
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }
    this.UserName = this._proyectoService.UsuarioLogeado;
    //this.getUserRole();
    //Recogemos el rol del usuario
    this._proyectoService.getRolesUsuario().subscribe(
      res => {

        this.permisosDeUsuario = res;
        //Si no hay errores y son recogidos busca si tienes permisos de usuario
        for (let num = 0; num < this.permisosDeUsuario.length; num++) {
          if (this.permisosDeUsuario[num].role == "Administrador") {
            if (this.Project == null || this.Project == undefined || this.Project.id == -1) {
              this.Project = { id: 0, nombre: '', fecha: null, numFinishedEvals:0, numPendingEvals: 0};
              this.Admin = true;
            }
          }
        }

        //Comprueba que tenga  un proyecto seleccionado y si no es asi lo devuelve a home
        if (this.Project == null || this.Project == undefined) {
          this._router.navigate(['/home']);
        } else if (this.Project.id == -1 && !this.Admin) {
          this._router.navigate(['/home']);
        } else {
          this.MostrarInfo = true;
        }
        
        this.GetPaginacion();


      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + "No pudimos recoger los datos del usuario.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      },
      () => {
        //this.Restablecer();
      });

    if (this.Project.fecha != null) {
      //Para que no de error en modo development
      setTimeout(() => {
        this._appComponent.anadirUserProyecto(this.UserName, this._proyectoService.UserLongName, this.Project.nombre);
      },0);
    } else {
      //Para que no de error en modo development
      setTimeout(() => {
        this._appComponent.anadirUserProyecto(this.UserName, this._proyectoService.UserLongName, "Todos");
      },0);

    }
  }


  //Recarga los elementos en la pagina en la que se encuentra 
  public GetPaginacion() {
    this.Mostrar = false;
    this._evaluacionService.GetEvaluationsWithProgress(this.Project.id, this.EvaluacionFiltrar)
      .subscribe(
        res => {
          this.nEvaluaciones = res.numEvals;
          this.ListaDeEvaluacionesPaginada = res.evaluacionesResult; 
          this.Mostrar = true; 

          if(this.ListaDeEvaluacionesPaginada.length > 0){        
            this.ListaDeEvaluacionesPaginada.forEach(ev => {
              
            });

           
          }

          
         
        },
        error => {
          if (error == 404) {
            this.ErrorMessage = "Error: " + error + " No pudimos recoger la información de las evaluaciones, lo sentimos.";
          } else if (error == 500) {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          } else if (error == 401) {
            this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
          } else {
            this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
          }
        });

  }

  

  public VolverInicio() {
    this._router.navigate(['/home']);
  }

  public getUserRole(){
    this._proyectoService.getRolesUsuario().subscribe(
      res => {
        var permisosDeUsuario = res;
        this._appComponent._storageDataService.Role = permisosDeUsuario.role;
      },
      error => {
        
      });
  }
}
