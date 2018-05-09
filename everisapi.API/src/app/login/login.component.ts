import { Component, OnInit } from '@angular/core';
import { UserService } from '../services/UserService';
import { AppComponent } from '../app.component';
import { User } from 'app/Models/User';
import {Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  providers: [UserService]
})
export class LoginComponent implements OnInit {

    public ErrorMessage: string = null;
    public nombreDeUsuario: string="";
    public passwordDeUsuario: string="";
    private UsuarioEntrante: User = null;
    public Recuerdame: boolean=false;

    constructor(private _userService : UserService,
        private _router: Router,
        private _app: AppComponent) { }


    ngOnInit() {
        //Comprobamos si anteriormente queria que se recordara su usuario
        if(this.recuerdameOnOff()){
            this.nombreDeUsuario= localStorage.getItem("user");
            this.passwordDeUsuario= localStorage.getItem("passuser");
            this.Recuerdame=true;
        }
    }

    //Mediante este metodo comprobaremos si el usuario espcificado existe o no
    //si es así sera redirigido a la pagina principal
    public SignUp(){
        //Comprueba si los campos tienen datos
        if(this.nombreDeUsuario!="" && this.passwordDeUsuario!=""){
            //Manda una petición a la api para ver si el nombre existe
            this._userService.SignUpMe(this.nombreDeUsuario).subscribe(
                res => {
                    //Si no existe muestra un error
                    if(!res){
                        this.ErrorMessage = "No existe el usuario especificado."
                    }else{
                        //Si existe comprueba si la contraseña es correcta y es redirigido
                        this.UsuarioEntrante = res;
                        if(this.UsuarioEntrante.password==this.passwordDeUsuario){
                            if(this.Recuerdame){
                                //Si el usuario quiere ser recordado lo guardara en el localStorage
                                localStorage.setItem("user", this.UsuarioEntrante.nombre);
                                localStorage.setItem("passuser", this.UsuarioEntrante.password);
                            }else{
                                //Si el usuario no quiere ser recordado lo guardara en el servicio
                                this._app._storageDataService.UserData = this.UsuarioEntrante;
                            }
                            this._router.navigate(['/home']);
                        }else{
                            //Si no es correcta borra el usuario recogido y muestra mensaje de error
                            this.ErrorMessage = "El nombre de usuario o contraseña no son correctos.";
                            this.UsuarioEntrante = null;
                        }
                    }
                },
                error => {
                    //Si el servidor tiene algún tipo de problema mostraremos este error
                    if(error==404){
                        this.ErrorMessage = "El nombre de usuario o contraseña no son correctos.";
                    }else if(error==500){
                        this.ErrorMessage = "Ocurrio un error en el servidor, contacte con el servicio técnico.";
                    }
                }	
            );
        }else{
            this.ErrorMessage="Introduzca todos los campos."
        }
    }

    //Este metodo devuelve si el usuario estaba siendo recordado
    //Lo utilizamos en el html para cambiar el recuerdame y en el init del componente
    public recuerdameOnOff(){
        if(localStorage.getItem("user")!=null && localStorage.getItem("user")!=undefined){
            return true;
        }else{
            return false;
        }
    }

    //Este metodo nos permite saber si el usuario quiere ser recordado
    public recuerdameChange(){
        if(this.Recuerdame){
            localStorage.removeItem("user");
            localStorage.removeItem("passuser");
            this.Recuerdame=false;
        }else{
            this.Recuerdame=true;
        }
    }

    /*public Prueba(){
        this._userService.getUsers().subscribe(
            res => {
                if(!res){
                    console.log("No hay usuarios")
                }else{
                    console.log("Usuarios encontrados: "+res);
                }
            },
            error => {
                console.log("Lo sentimos ocurrio un error en al realizar la petición.");

            }	
        );
    }*/

}
