import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/UserService';
import { ProyectoService } from 'app/services/ProyectoService';
import { Router } from "@angular/router";
import { UserWithRole } from 'app/Models/UserWithRole';
import { AppComponent } from 'app/app.component';





@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss'],
  providers: [UserService, ProyectoService]
})



export class UserManagementComponent implements OnInit {

  public ErrorMessage: string = null;
  public ListaDeUsuarios: UserWithRole[] = [];
  name = 'Angular 5';
  query:string = '';
  
  
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

    console.log(this.ListaDeUsuarios);
    }


  public getAllUsers(){

     this._UserService.getUsers().subscribe(
      res => {this.ListaDeUsuarios = res; 
        console.log(this.ListaDeUsuarios);
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


  

}
