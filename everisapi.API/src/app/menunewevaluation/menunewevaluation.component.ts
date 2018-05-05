import { Component, OnInit } from '@angular/core';
import { EvaluacionService } from '../services/EvaluacionService';
import { AppComponent } from '../app.component';
import { Section } from './Section';
import { Router } from "@angular/router";
import { Proyecto } from 'app/login/Proyecto';
import { ProyectoService } from '../services/ProyectoService';
import { async } from '@angular/core/testing';

@Component({
  selector: 'app-menunewevaluation',
  templateUrl: './menunewevaluation.component.html',
  styleUrls: ['./menunewevaluation.component.scss'],
  providers: [EvaluacionService, ProyectoService]
})
export class MenunewevaluationComponent implements OnInit {

  public ErrorMessage: string = null;
  public ListaSections: Array<Section> = [];
  public ListaNumPreguntas: Array<number> = [];
  public ListaNumRespuestas: Array<number> = [];
  public ProjectSelected: Proyecto;
  public UserSelected: string;


  constructor(
    private _proyectoService: ProyectoService,
    private _evaluacionService: EvaluacionService,
    private _router: Router,
    private _appComponent: AppComponent)
  {

    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En caso de no estar logeado nos enviara devuelta al login
    //En caso de no tener asignado ningun proyecto nos enviara a home para que lo seleccionemos
    this.ProjectSelected = this._appComponent._storageDataService.UserProjectSelected;
    console.log("encontramos que: ", this.ProjectSelected)
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    } else if (this.ProjectSelected == null || this.ProjectSelected == undefined) {
      this._router.navigate(['/home']);
    }

    //Recogemos el nombre del usuario con el que nos logueamos
    this.UserSelected = this._proyectoService.UsuarioLogeado;


    //Recogemos todas las sections
    this._evaluacionService.getSections().subscribe(
      res => {
        if (res != null) {
          this.ListaSections = res;
          //Le damos la información
          this.GetDataPreguntas(this.ListaSections[0].id, this.ProjectSelected.id);
        } else {
          this.ErrorMessage = "No esta disponible ninguna sección, contacte con el servicio tecnico porfavor.";
        }
      },
      error => {
        this.ErrorMessage = "Ocurrio un error con el servidor, lo sentimos.";
      }
    );
  }

  ngOnInit() {
    
  }

  //Calcula el total de las ceremonias que llevamos completadas de forma dinamica
  public CalcularPorcentaje(preguntasRespondidas:number, totalPreguntas:number){
    //Calculamos el porcentaje de las preguntas respondidas a partir del total
    var Total= (preguntasRespondidas/totalPreguntas)*100;
    //Redondeamos el porcentaje obtenido y lo devolvemos
    return Math.round(Total*10)/10;
  }

  //Permite refirigir y guardar la id de la sección seleccionada
  public RedirectToAsignaciones(id: number) {
    this._appComponent._storageDataService.IdSection = id;
    this._router.navigate(['/nuevaevaluacion']);
  }

  //Este metodo nos permite recoger el número de preguntas y de respuestas para cada sección
  //Deberemos introducir una id de proyecto y la id de la sección
  public GetDataPreguntas(idSection: number, idProject: number) {

      //Recogemos el numero de preguntas
      this._evaluacionService.getPreguntasSection(idSection, idProject).subscribe( 
         res => {
          if (  res != null) {
            this.ListaNumPreguntas.push(res);
          } else {
            console.log("error preguntas1");
          }
        },
        error => {
          console.log("error preguntas2");
        });

      //Recogemos el numero de respuestas
      this._evaluacionService.getRespuestasSection(idSection, idProject).subscribe(
        res => {
         if ( res != null) {
           this.ListaNumRespuestas.push(res);
           if (idSection < this.ListaSections.length) {
             this.GetDataPreguntas(this.ListaSections[idSection].id, idProject);
           }
          } else {
            console.log("error respuestas1");
          }
        },
        error => {
          console.log("error respuestas2");
        });
    

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
