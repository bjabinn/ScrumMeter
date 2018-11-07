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
  public radioSelected;
  
  
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
    this.getAllRoles();
    this.radioSelected = this.ListaDeRoles[0];

    }


  public getAllUsers(){

     this._UserService.getUsers().subscribe(
      res => {this.ListaDeUsuarios = res;},
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

  public getAllRoles(){

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

 public getAllProjects(){
   
 }

  public SeleccionDeUsuario(index: number) {
    console.log("usuario",index);
    
    this.UsuarioSeleccionado = this.ListaDeUsuarios[index];

    this.radioSelected = this.UsuarioSeleccionado;

    console.log(this.UsuarioSeleccionado);
    
  }

  public SeleccionDeRol(){
    
    this.UsuarioSeleccionado.role = this.radioSelected;
    console.log("rol", this.radioSelected);
  }


  

}
