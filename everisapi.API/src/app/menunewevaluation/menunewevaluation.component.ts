import { Component, OnInit } from '@angular/core';
import { SectionService } from '../services/SectionService';
import { EvaluacionService } from '../services/EvaluacionService';
import { ProyectoService } from '../services/ProyectoService';
import { AppComponent } from '../app.component';
import { Section } from 'app/Models/Section';
import { Router } from "@angular/router";
import { Proyecto } from 'app/Models/Proyecto';
import { async } from '@angular/core/testing';
import { Evaluacion } from 'app/Models/Evaluacion';
import { SectionInfo } from 'app/Models/SectionInfo';
import { LoadingComponent } from '../loading/loading.component';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap'; 

@Component({
  selector: 'app-menunewevaluation',
  templateUrl: './menunewevaluation.component.html',
  styleUrls: ['./menunewevaluation.component.scss'],
  providers: [SectionService, ProyectoService, EvaluacionService]
})
export class MenunewevaluationComponent implements OnInit {

  public ErrorMessage: string = null;
  public ListaDeDatos: Array<SectionInfo> = [];
  public ProjectSelected: Proyecto;
  public Evaluacion: Evaluacion = null;
  public UserSelected: string;


  constructor(
    private _proyectoService: ProyectoService,
    private _sectionService: SectionService,
    private _router: Router,
    private _evaluacionService: EvaluacionService,
    private _appComponent: AppComponent,
    private modalService: NgbModal)
  {

    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En caso de no estar logeado nos enviara devuelta al login
    //En caso de no tener asignado ningun proyecto nos enviara a home para que lo seleccionemos
    this.ProjectSelected = this._appComponent._storageDataService.UserProjectSelected;
    this.Evaluacion = this._appComponent._storageDataService.Evaluacion;
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    } else if (this.ProjectSelected == null || this.ProjectSelected == undefined || this.Evaluacion == null || this.Evaluacion == undefined) {
      this._router.navigate(['/home']);
    }
    //Recogemos el nombre del usuario con el que nos logueamos
    this.UserSelected = this._proyectoService.UsuarioLogeado;

    //Recogemos todos los datos
    this._sectionService.getSectionInfo(this.Evaluacion.id).subscribe(
      res => {
        this.ListaDeDatos = res;
      },
      error => {
        console.log("Error al recoger los datos.")
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

  //Este metodo guarda la evaluacion y cambia su estado como finalizado
  public FinishEvaluation() {
    this.Evaluacion.estado = true;
    this._evaluacionService.updateEvaluacion(this.Evaluacion).subscribe(
      res => {
        this._router.navigate(['/home']);
      },
      error => {
        console.log("ocurrio un error en el update: " + error);
      });
  }

  public AbrirModal(content) {
    this.modalService.open(content).result.then(
      (closeResult) => {
        //Esto realiza la acción de cerrar la ventana
        //Console.log("Cerro la ventana con: ", content);
      }, (dismissReason) => {
        if (dismissReason == 'Home') {
          //Si no desea finalizar lo mandaremos a home
          this._router.navigate(['/home']);
        } else if (dismissReason == 'Finish') {
          //Si decide finalizarlo usaremos el metodo para finalizar la evaluación
          this.FinishEvaluation();
        }

      })
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
