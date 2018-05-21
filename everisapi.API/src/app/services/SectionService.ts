import { Injectable, Inject } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import { GLOBAL } from './global';
import { AppComponent } from 'app/app.component';

@Injectable()
export class SectionService {
  public identity;
  public token;
  public url: string;

  constructor(private _http: Http,
    private _appComponent: AppComponent) {
    this.url = GLOBAL.url;
  }

  //Este metodo recoge todos los usuarios de la base de datos
  getSections() {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections', { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Este metodo recoge un usuario si existe mediante un nombre de usuario
  getOneSection(id) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections/' + id, { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Este metodo recoge un usuario si existe mediante un nombre de usuario
  getAsignacionesSection(id) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections/' + id + '/asignaciones', { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Devuelve el numero de preguntas para cada sección segun que proyecto selecciones
  getPreguntasSection(idSection, idProject) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections/' + idSection + '/evaluacion/' + idProject + "/preguntas", { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Devuelve el numero de respuestas correctas para cada sección segun que proyecto selecciones
  getRespuestasSection(idSection, idProject) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections/' + idSection + '/evaluacion/' + idProject + "/respuestas", { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Recoge todos los datos extendidos de una evaluación
  getSectionInfo(idEvaluacion) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'sections/evaluacion/' + idEvaluacion, { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Devuelve las preguntas para una asignación en especifico
  getPreguntasArea(id) {
    let Token = this._appComponent.ComprobarUserYToken();
    let headers = new Headers({
      'Authorization': Token
    });
    return this._http.get(this.url + 'asignaciones/' + id + '/preguntas', { headers: headers })
      .map((response: Response) => response.json())
      .catch(this.errorHandler);
  }

  //Implementamos este metodo para permitir la recogida de los errores y su gestión
  errorHandler(error: Response) {
    return Observable.throw(error.status);
  }

}
