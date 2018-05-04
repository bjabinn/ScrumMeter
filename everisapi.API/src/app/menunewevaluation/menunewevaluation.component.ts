import { Component, OnInit } from '@angular/core';
import { EvaluacionService } from '../services/EvaluacionService';
import { AppComponent } from '../app.component';
import { Section } from './Section';
import { Router } from "@angular/router";
import { Proyecto } from 'app/login/Proyecto';
import { ProyectoService } from '../services/ProyectoService';

@Component({
  selector: 'app-menunewevaluation',
  templateUrl: './menunewevaluation.component.html',
  styleUrls: ['./menunewevaluation.component.scss'],
  providers: [EvaluacionService, ProyectoService]
})
export class MenunewevaluationComponent implements OnInit {

  public ListaSections: Array<Section>;
  public ProjectSelected: Proyecto;
  public UserSelected: string;

  numeroPreguntasCeremonias: number=26;
  preguntasRespondidasCeremonias: number=10;

  numeroPreguntasRoles: number=15;
  preguntasRespondidasRoles: number=0;

  numeroPreguntasArtefactos: number=28;
  preguntasRespondidasArtefactos: number=28;

  constructor(
    private _proyectoService: ProyectoService,
    private _evaluacionService: EvaluacionService,
    private _router: Router,
    private _appComponent: AppComponent) { }

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    this.ProjectSelected = this._appComponent._storageDataService.UserProjectSelected;
    if (!this._proyectoService.verificarUsuario() || this.ProjectSelected == null || this.ProjectSelected == undefined) {
      this._router.navigate(['/login']);
    }

    //Recogemos el nombre del usuario con el que nos logueamos
    this.UserSelected = this._proyectoService.UsuarioLogeado;

    
    this._evaluacionService.getSections().subscribe(
      res => {
        if (res != null) {
          this.ListaSections = res;
          console.log("sections: ", this.ListaSections);
        } else {
          console.log("Esto esta muy vacio");
        }
      },
      error => {
        console.log("error lista Sections");
      }
    );
  }

  //Calcula el total de las ceremonias que llevamos completadas de forma dinamica
  public CalcularPorcentaje(preguntasRespondidas:number, totalPreguntas:number){
    //Calculamos el porcentaje de las preguntas respondidas a partir del total
    var Total= (preguntasRespondidas/totalPreguntas)*100;
    //Redondeamos el porcentaje obtenido y lo devolvemos
    return Math.round(Total*10)/10;
  }

  public RedirectToAsignaciones(id: number) {
    this._appComponent._storageDataService.IdSection = id;
    this._router.navigate(['/nuevaevaluacion']);
  }

/*
  //Metodo de prueba para probar el dinamismo del componente
  public ProbarDinamico(Opcion:boolean){
    if(Opcion){
        if(this.preguntasRespondidasArtefactos<this.numeroPreguntasArtefactos){
            this.preguntasRespondidasArtefactos++;
        }

        if(this.preguntasRespondidasCeremonias< this.numeroPreguntasCeremonias){
            this.preguntasRespondidasCeremonias++;
        }

        if(this.preguntasRespondidasRoles< this.numeroPreguntasRoles){
            this.preguntasRespondidasRoles++;
        }
    }else{
        if(this.preguntasRespondidasArtefactos>0){
            this.preguntasRespondidasArtefactos--;
        }

        if(this.preguntasRespondidasCeremonias>0){
            this.preguntasRespondidasCeremonias--;
        }

        if(this.preguntasRespondidasRoles>0){
            this.preguntasRespondidasRoles--;
        }
    }
  }
*/
 
}
