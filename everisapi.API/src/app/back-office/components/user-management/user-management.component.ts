import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/UserService';
import { ProyectoService } from 'app/services/ProyectoService';
import { Router } from "@angular/router";
import { UserWithRole } from 'app/Models/UserWithRole';
import { AppComponent } from 'app/app.component';
import { Role } from 'app/Models/Role';





@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss'],
  providers: [UserService, ProyectoService]
})



export class UserManagementComponent implements OnInit {

  public ErrorMessage: string = null;
  public ListaDeUsuarios: UserWithRole[] = [];
  public UsuarioSeleccionado: UserWithRole;
  public ListaDeRoles: Role[] = [];
  
  
  constructor(
    private _UserService: UserService, 
    private _proyectoService: ProyectoService,
    private _router: Router,
    private _appComponent: AppComponent
    ){ }

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }
    this.getAllUsers();
    this.getAllRolesFront();

    }


  public getAllUsers(){

     this._UserService.getUsers().subscribe(
      res => {this.ListaDeUsuarios = res; 
        //console.log(this.ListaDeUsuarios);
      }
      ,
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });  
  }

  public getAllRolesFront(){

    this._UserService.getAllRoles().subscribe(
     res => {this.ListaDeRoles = res; 
       console.log(this.ListaDeRoles);
     }
     ,
     error => {
      console.log("explota explota mi corazzon");
       //Si el servidor tiene algún tipo de problema mostraremos este error
       if (error == 404) {
         this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
       } else if (error == 500) {
         this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
       } else if (error == 401) {
         this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
       } else {
         this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
       }
     });

    
 }

  public SeleccionDeUsuario(index: number) {
    console.log("usuario",index);
    
    this.UsuarioSeleccionado = this.ListaDeUsuarios[index];

    console.log(this.UsuarioSeleccionado);
    
    //his._appComponent._storageDataService.UsuarioSeleccionado = this.UsuarioSeleccionado;
    //this.existeRepetida = false;


    //Comprueba que no esta vacia el proyecto elegido
    // if (this.checkIfIsSet(this.UsuarioSeleccionado)) {
    //   //Comprueba si ya termino de enviarse la información desde la api
    //   if (!this.SendingInfo) {
    //     this.SendingInfo = true;
    //     this._evaluacionService.getIncompleteEvaluacionFromProjectAndAssessment(this.ProyectoSeleccionado.id,this.AssessmentSelected.assessmentId).subscribe(
    //       res => {
    //         //Lo guarda en el storage
    //         this._appComponent._storageDataService.Evaluacion = res;
    //         //Si hay un proyecto sin finalizar
    //         console.log("XXXXX",res);
    //         if (res != null) {
    //           this.existeRepetida = true;
    //         } 
    //       },
    //       error => {
    //         //Habilitamos la pagina nuevamente
    //         this.Deshabilitar = false;
    //         if (error == 404) {
    //           this.ErrorMessage = "Error: " + error + " No se puede completar la comprobación en la evaluación lo sentimos.";
    //         } else if (error == 500) {
    //           this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
    //         } else if (error == 401) {
    //           this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
    //         } else {
    //           this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
    //         }
    //       },
    //       () => {
    //         this.SendingInfo = false;
    //       });
    //   }
    // }

  }

  public SeleccionDeRol(){
console.log("asdasd");
  }


  

}
