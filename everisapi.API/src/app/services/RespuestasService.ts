import { Injectable, Inject } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import { GLOBAL } from './global';
import { AppComponent } from '../app.component';

@Injectable()
export class RespuestasService {

  private url: string;

  constructor(private _http: Http) {
    this.url = GLOBAL.url;
  }


  //Este metodo devuelve todas las respuestas de una asignacion en un proyecto
  getRespuestasAsigProy(idProyecto: number, idAsignacion: number) {
    console.log("Desde el servicio seria la url: " + this.url + 'respuestas/proyecto/' + idProyecto + '/asignacion/' + idAsignacion);
    return this._http.get(this.url + 'respuestas/proyecto/' + idProyecto + '/asignacion/' + idAsignacion)
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Este metodo altera el valor de la respuesta en la base de datos
  AlterEstadoRespuesta(id: number, change: boolean) {
    let httpParams = new HttpParams();
    let headers = new Headers({
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    console.log("Desde el servicio: ", this.url + 'respuestas/' + id + '/change/' + change);
    return this._http.put(this.url + 'respuestas/' + id + '/change/' + change, httpParams, { headers: headers })
      .map(res => console.log(res));
  }

  //Implementamos este metodo para permitir la recogida de los errores y su gestión
  errorHandler(error: Response) {
    return Observable.throw(error.status);
  }

}
