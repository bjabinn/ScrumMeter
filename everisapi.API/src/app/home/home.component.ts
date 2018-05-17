import { Component, OnInit } from '@angular/core';
import { User } from 'app/Models/User';
import { Role } from 'app/Models/Role';
import { Proyecto } from 'app/Models/Proyecto';
import { ProyectoService } from '../services/ProyectoService';
import { EvaluacionService } from '../services/EvaluacionService';
import { Router } from "@angular/router";
import { AppComponent } from '../app.component';
import { Evaluacion } from 'app/Models/Evaluacion';
import { EvaluacionCreate } from 'app/Models/EvaluacionCreate';
import { FormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap'; 
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { LoadingComponent } from '../loading/loading.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  providers: [ProyectoService, EvaluacionService]
})
export class HomeComponent implements OnInit {
    public ErrorMessage: string = null;
    public ListaDeProyectosAdmin:Array<Proyecto> = [];
    public ListaDeProyectos:Array<Proyecto> = [];
    public permisosDeUsuario: Array<Role> = [];
    public AdminOn = false;
    public ProyectoSeleccionado:Proyecto;
    public NombreDeUsuario: string;
    public Deshabilitar = false;

  constructor(
            private _proyectoService: ProyectoService,
            private _evaluacionService: EvaluacionService,
            private modalService:NgbModal,
            private _router: Router,
            private _appComponent: AppComponent) {}

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    if(!this._proyectoService.verificarUsuario()){
        this._router.navigate(['/login']);
    }

    //Recogemos el nombre del usuario con el que nos logueamos
    this.NombreDeUsuario = this._proyectoService.UsuarioLogeado;

    //Reiniciamos los proyectos seleccionados en el servicio
    this._appComponent._storageDataService.UserProjectSelected = { id: null, nombre: '', fecha: null };

    //Intentamos recoger los roles de los usuarios
    this._proyectoService.getRolesUsuario().subscribe(
        res => {
            
            this.permisosDeUsuario=res;
            //Si no hay errores y son recogidos busca si tienes permisos de usuario
            for (let num = 0; num < this.permisosDeUsuario.length; num++) {
                if(this.permisosDeUsuario[num].role == "Administrador"){
                    this.AdminOn=true;
                }
            }
            //Llamamos al metodo para asignar proyectos
            this.RecogerProyectos();

        },
        error =>{
            //Si el servidor tiene algún tipo de problema mostraremos este error
            if(error==404){
                this.ErrorMessage = "El usuario autenticado no existe.";
            }else if(error==500){
                this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
            }
        });
  }

  //Metodo que asigna los proyectos por permisos y usuario
  public RecogerProyectos(){
    
    //Segun el tipo de rol que tengas te permitira tener todos los proyectos o solo los tuyos
    //El servicio se encargara de enviar una respuesta con el listado de proyecto
    //El usuario necesario ya tendria que haber sido cargado en el logueo
    if(!this.AdminOn){
        //Aqui se entra solo si no tienes permisos de administrador dandote los proyectos que te tocan
        this._proyectoService.getProyectosDeUsuario().subscribe(
            res => {
                this.ListaDeProyectos=res;
            },
            error =>{
                //Si el servidor tiene algún tipo de problema mostraremos este error
                if(error==404){
                    this.ErrorMessage = "El usuario autenticado no existe.";
                }else if(error==500){
                    this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
                }
            });
        }else{
            //Aqui entra si eres administrador dandote todos los proyectos
            this._proyectoService.getAllProyectos().subscribe(
                res => {
                    this.ListaDeProyectos=res;
                },
                error =>{
                    //Si el servidor tiene algún tipo de problema mostraremos este error
                    if(error==404){
                        this.ErrorMessage = "El usuario autenticado no existe.";
                    }else if(error==500){
                        this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
                    }
                });

            //Tambien recogemos los proyectos del administrador para saber cuales son asignados a el
            this._proyectoService.getProyectosDeUsuario().subscribe(
                res => {
                    this.ListaDeProyectosAdmin=res;
                },
                error =>{
                    //Si el servidor tiene algún tipo de problema mostraremos este error
                    if(error==404){
                         this.ErrorMessage = "El usuario autenticado no existe.";
                    }else if(error==500){
                        this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
                     }
                });
        }
  }

  //Este metodo guarda el proyecto que a sido seleccionado en el front
  public SeleccionDeProyecto(index: number) {
    this.ProyectoSeleccionado = this.ListaDeProyectos[index];
    this._appComponent._storageDataService.UserProjectSelected = this.ProyectoSeleccionado;
  }

  //Este metodo crea una nueva evaluación y la manda para guardarla en la base de datos
  public GuardarEvaluacion() {
    var NuevaEvaluacion: EvaluacionCreate = { 'estado': false, 'proyectoid': this.ProyectoSeleccionado.id};
    this._evaluacionService.addEvaluacion(NuevaEvaluacion).subscribe(
      res => {
        this._appComponent._storageDataService.Evaluacion = res;
        this._router.navigate(['/menunuevaevaluacion']);
      },
      error => {
        this.ErrorMessage = "Error al guardar la evaluación, " + error; 
      });
  }

  //Este metodo consulta las evaluaciones anteriores de este proyecto si esta seleccionado y existe
  public EvaluacionesAnteriores(){
    if (this.AdminOn || this.ProyectoSeleccionado != null && this.ProyectoSeleccionado != undefined) {
        this._router.navigate(['/evaluacionprevia']);
    }else{
        this.ErrorMessage= "Seleccione un proyecto para realizar esta acción.";
    }
  }

  //Este metodo guarda la evaluacion y cambia su estado como finalizado
  public FinishEvaluation() {
    //Recoge la evaluación
    var Evaluacion = this._appComponent._storageDataService.Evaluacion;

    //La cambia a temrinada
    Evaluacion.estado = true;

    //La envia a la base de datos ya terminada
    this._evaluacionService.updateEvaluacion(Evaluacion).subscribe(
      res => {
        //Una vez terminado guarda una nueva evaluación
        this.GuardarEvaluacion();
      },
      error => {
        this.ErrorMessage = "Error al actualizar la base de datos, " + error;
        
      });
  }

  //Muestra un modal con lo que se debe hacer en cada caso
  showModal(content) {
    //Deshabilito la parte de atras del modal
    this.Deshabilitar = true;
    //Comprueba si existe un proyecto seleccionado
    if (this.ProyectoSeleccionado != null && this.ProyectoSeleccionado != undefined) {
      this._evaluacionService.getIncompleteEvaluacionFromProject(this.ProyectoSeleccionado.id).subscribe(
        res => {
          //Habilitamos la pagina nuevamente
          this.Deshabilitar = false;
          //Si hay un proyecto sin finalizar muestra un modal y deja seleccionar
          if (res != null) {
            this.modalService.open(content).result.then(
              (closeResult) => {

              }, (dismissReason) => {
                //Lo guarda en el storage
                this._appComponent._storageDataService.Evaluacion = res;
                //Si selecciona continuar cargara la valuación que no termino
                if (dismissReason == 'Continuar') {
                  this._router.navigate(['/menunuevaevaluacion']);
                } else if (dismissReason == 'Nueva'){
                  //Si selecciona nuevo que es la otra opción cogera la evaluación anterior lo finalizara
                  //cargara una nueva y lo mostrara
                  this.FinishEvaluation();
                }

              })

          } else {
            //Si no encuentra ninguna repetida directamente te crea una nueva evaluación
            this.GuardarEvaluacion();

          }
        },
        error => {
          //Habilitamos la pagina nuevamente
          this.Deshabilitar = false;
           this.ErrorMessage = "Error en la base de datos, " +error;
        });
    } else {
      this.ErrorMessage = "Seleccione un proyecto para realizar esta acción.";
    }


  }  

}
