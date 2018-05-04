import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-menunewevaluation',
  templateUrl: './menunewevaluation.component.html',
  styleUrls: ['./menunewevaluation.component.scss']
})
export class MenunewevaluationComponent implements OnInit {
  
  numeroPreguntasCeremonias: number=26;
  preguntasRespondidasCeremonias: number=10;

  numeroPreguntasRoles: number=15;
  preguntasRespondidasRoles: number=0;

  numeroPreguntasArtefactos: number=28;
  preguntasRespondidasArtefactos: number=28;

  constructor() { }

  ngOnInit() {
    
  }

  //Calcula el total de las ceremonias que llevamos completadas de forma dinamica
  public CalcularPorcentaje(preguntasRespondidas:number, totalPreguntas:number){
    //Calculamos el porcentaje de las preguntas respondidas a partir del total
    var Total= (preguntasRespondidas/totalPreguntas)*100;
    //Redondeamos el porcentaje obtenido y lo devolvemos
    return Math.round(Total*10)/10;
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
