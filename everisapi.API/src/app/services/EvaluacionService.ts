import { Injectable, Inject } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import { GLOBAL } from './global';

@Injectable()
export class EvaluacionService {
  public identity;
  public token;
  public url: string;

  constructor(private _http: Http) {
    this.url = GLOBAL.url;
  }

  //Este metodo recoge todos los usuarios de la base de datos
  getSections() {
    return this._http.get(this.url + 'sections')
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Este metodo recoge un usuario si existe mediante un nombre de usuario
  getOneSection(id) {
    return this._http.get(this.url + 'sections/' + id)
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Este metodo recoge un usuario si existe mediante un nombre de usuario
  getAsignacionesSection(id) {
    return this._http.get(this.url + 'sections/' + id+ '/asignaciones')
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }


  getPreguntasSection(id) {
    return this._http.get(this.url + 'asignaciones/' + id + '/preguntas')
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Implementamos este metodo para permitir la recogida de los errores y su gestión
  errorHandler(error: Response) {
    return Observable.throw(error.status);
  }

}
