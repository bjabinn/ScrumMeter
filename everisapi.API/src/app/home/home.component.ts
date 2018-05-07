import { Component, OnInit, OnDestroy, ContentChild, TemplateRef } from '@angular/core';
import { User } from '../login/User';
import { Role } from './Role';
import { Proyecto } from '../login/Proyecto';
import { ProyectoService } from '../services/ProyectoService';
import { Router } from "@angular/router";
import { AppComponent } from '../app.component';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  providers: [ProyectoService]
})
export class HomeComponent implements OnInit  {
  
    public ErrorMessage: string = null;
    public ListaDeProyectosAdmin:Array<Proyecto> = [];
    public ListaDeProyectos:Array<Proyecto> = [];
    public permisosDeUsuario: Array<Role> = [];
    public AdminOn = false;
    public ProyectoSeleccionado:Proyecto;
    public NombreDeUsuario: string;
    


  constructor(
            private _proyectoService: ProyectoService,
      private _router: Router,
      
           
        private _appComponent: AppComponent) { }

 

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    if(!this._proyectoService.verificarUsuario()){
        this._router.navigate(['/login']);
    }

    //Recogemos el nombre del usuario con el que nos logueamos
    this.NombreDeUsuario=this._proyectoService.UsuarioLogeado;

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
                })
        }
  }

  //Este metodo guarda el proyecto que a sido seleccionado en el front
  public SeleccionDeProyecto(ProyectoSeleccionado: Proyecto){
    this.ProyectoSeleccionado = ProyectoSeleccionado;
  }

  //Este metodo comprueba si el proyecto seleccionado es correcto y si es así pasa al siguiente elemento
  //Guardara los datos en el service de almacenamiento
  public NuevaEvaluacion(){

    if (this.ProyectoSeleccionado != null && this.ProyectoSeleccionado != undefined) {
      console.log("entrando")
      this._appComponent._storageDataService.UserProjectSelected = this.ProyectoSeleccionado;
      console.log("antes")
        this._router.navigate(['/menunuevaevaluacion']);
    }else{
        this.ErrorMessage= "Seleccione un proyecto para realizar esta acción.";
    }

  }

  //Este metodo consulta las evaluaciones anteriores de este proyecto si esta seleccionado y existe
  public EvaluacionesAnteriores(){
    if (this.ProyectoSeleccionado != null && this.ProyectoSeleccionado != undefined) {
        this._appComponent._storageDataService.UserProjectSelected = this.ProyectoSeleccionado;
        this._router.navigate(['/evaluacionprevia']);
    }else{
        this.ErrorMessage= "Seleccione un proyecto para realizar esta acción.";
    }
    }

    

}
