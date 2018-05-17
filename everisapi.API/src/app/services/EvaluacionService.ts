import { Injectable, Inject } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import { GLOBAL } from './global';
import { Evaluacion } from 'app/Models/Evaluacion';
import { EvaluacionCreate } from 'app/Models/EvaluacionCreate';
import { EvaluacionFilterInfo } from 'app/Models/EvaluacionFilterInfo';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Observable } from 'rxjs';
import { ajax } from 'rxjs/observable/dom/ajax';
import { map, retry, catchError } from 'rxjs/operators';
import { of } from 'rxjs/observable/of';
import { User } from 'app/Models/User';

    @Injectable()
    export class EvaluacionService
    {
      public identity;
      public token;
      public url: string;

      constructor(private _http: Http) {
        this.url = GLOBAL.url;
      }

      //Este metodo recoge todas las evaluaciones de la base de datos
      getEvaluaciones() {
        return this._http.get(this.url + 'evaluaciones')
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Este metodo recoge una evaluacion si existe mediante una id de evaluacion
      getEvaluacion(id) {
        return this._http.get(this.url + 'evaluaciones/' + id)
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Este metodo recoge una evaluacion con datos extendidos si existe mediante una id de evaluacion
      getEvaluacionInfo(id) {
        return this._http.get(this.url + 'evaluaciones/proyecto/' + id + '/info')
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Nos permite recoger información de las envaluaciones filtrada y paginada
      getEvaluacionInfoFiltered(NumPag: number, idProject: number, EvaluacionFiltrar: EvaluacionFilterInfo) {
        let params = JSON.stringify(EvaluacionFiltrar);
        let headers = new Headers({
          'Content-Type': 'application/json'
        });
        return this._http.post(this.url + 'evaluaciones/proyecto/'+idProject+'/info/page/'+NumPag, params, { headers: headers })
          .map(res => res.json())
          .catch(this.errorHandler);
      }

      //Este metodo recoge una evaluacion de un proyecto si existe mediante una id de proyecto
      getEvaluacionFromProject(id) {
        return this._http.get(this.url + 'evaluaciones/proyecto/'+id)
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Este metodo recoge el número de evaluaciones de un proyecto o todos los proyectos
      getNumEvals(id) {
        return this._http.get(this.url + 'evaluaciones/proyecto/' + id + '/num')
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Devuelve una evaluacion si existe una que no se completo en ese proyecto
      getIncompleteEvaluacionFromProject(id) {
        return this._http.get(this.url + 'evaluaciones/proyecto/' + id + '/continue')
          .map((response: Response) => response.json())
          .catch(this.errorHandler);
      }

      //Nos permite incluir una evaluacion en la base de datos
      addEvaluacion(evaluacion: EvaluacionCreate) {
        let params = JSON.stringify(evaluacion);
        let headers = new Headers({
          'Content-Type': 'application/json'
        });
        return this._http.post(this.url + 'evaluaciones', params, { headers: headers })
          .map(res => res.json())
          .catch(this.errorHandler);
      }

      //Nos permite realizar un update de una evaluacion en la base de datos
      updateEvaluacion(evaluacion: Evaluacion) {
        let params = JSON.stringify(evaluacion);
        let headers = new Headers({
          'Content-Type': 'application/json'
        });

        return this._http.put(this.url + 'evaluaciones', params, { headers: headers })
          .map(res => res)
          .catch(this.errorHandler);
      }

      //Implementamos este metodo para permitir la recogida de los errores y su gestión
      errorHandler(error: Response) {
        return Observable.throw(error.status);
      }
    }

