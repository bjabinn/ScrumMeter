import { Injectable, Inject } from '@angular/core';  
import { Http, Response } from '@angular/http';  
import { Observable } from 'rxjs/Observable';  
import { Router } from '@angular/router';  
import 'rxjs/add/operator/map';  
import 'rxjs/add/operator/catch';  
import 'rxjs/add/observable/throw'; 
import { GLOBAL } from './global';
import { AppComponent } from '../app.component';

@Injectable()
export class ProyectoService{
    public url: string;
    public UsuarioLogeado: string;

    constructor(private _http: Http, 
        private _app: AppComponent){
		this.url = GLOBAL.url;
    }
    
    //Este metdo nos permite verificar si el usuario ya esta logeado en la web
    //Puede estar recordado o puede estar iniciado solo para esta sesión
    //Si no esta logeado de ninguna manera enviara false
    public verificarUsuario(){
        var local = localStorage.getItem("user");
        var storage = this._app._storageDataService.UserData;
        if(local!=null && local!=undefined){
            this.UsuarioLogeado = localStorage.getItem("user");
            return true;
        }else if(storage!=undefined && storage!=null){
            this.UsuarioLogeado = this._app._storageDataService.UserData.nombre;
            return true;
        }else{
            return false;
        }
    }
    
    //Este metodo devuelve todos los proyectos de todos los usuarios
    getAllProyectos(){
        return this._http.get(this.url + 'users/fullproyectos')  
            .map((response: Response) => response.json())  
            .catch(this.errorHandler);
    }

    //Este metodo recoge todos los proyectos de un usuario de la base de datos
	getProyectosDeUsuario(){
		return this._http.get(this.url + 'users/'+this.UsuarioLogeado+"/proyectos")  
            .map((response: Response) => response.json())  
            .catch(this.errorHandler);
    }

    //Este metodo recoge un proyecto de un usuario si existe mediante un nombre de usuario y su id de proyecto
    getOneProjecto(idProyecto){
        return this._http.get(this.url + 'users/'+this.UsuarioLogeado+'/proyecto/'+idProyecto)  
            .map((response: Response) => response.json())  
            .catch(this.errorHandler);
    }

    //Este metodo devuelve todos los permisos de un usuario
    getRolesUsuario(){
        return this._http.get(this.url + 'users/'+this.UsuarioLogeado+'/roles')  
        .map((response: Response) => response.json())  
        .catch(this.errorHandler);
    }
    
    //Implementamos este metodo para permitir la recogida de los errores y su gestión
    errorHandler(error: Response) { 
        return Observable.throw(error.status);  
    }  

}
