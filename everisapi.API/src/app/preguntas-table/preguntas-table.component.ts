import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import {animate, state, style, transition, trigger} from '@angular/animations';
import {PreviousevaluationComponent} from 'app/previousevaluation/previousevaluation.component'
import { AppComponent } from 'app/app.component';
import { RespuestaConNotas } from 'app/Models/RespuestaConNotas';
import { RespuestaConNotasTabla } from 'app/pdfgenerator/pdfgenerator.component';

// export interface Evaluacion {
//   id: number,
//   fecha: string;
//   nombre: string,
//   userNombre: string;
//   puntuacion: number;
//   estado: boolean;
//   notasEv: string;
//   notasOb: string;
//   assessmentName: string;
// }

@Component({
  selector: 'preguntas-table',
  templateUrl: './preguntas-table.component.html',
  styleUrls: ['./preguntas-table.component.scss'],
  animations: [
    trigger('detailExpand', [
    state('collapsed, void', style({ height: '0px', minHeight: '0', display: 'none' })),
    state('expanded', style({ height: '*' })),
    transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    transition('expanded <=> void', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)'))
    ]),
  ],
})

export class PreguntasTableComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @Input() dataInput: any;//Array<EvaluacionInfo>;
  dataSource: MatTableDataSource<RespuestaConNotas>;
  userRole: string;
  expandedElement: RespuestaConNotas;
  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = ['seccion', 'modulo', 'pregunta', 'respuesta', 'notas'];

  ngOnInit() {
    this.dataSource = new MatTableDataSource(this.dataInput);
    this.dataSource.sort= this.sort;
    this.dataSource.paginator = this.paginator;
    this.userRole = this._appComponent._storageDataService.Role;
    
  //   this.dataSource.filterPredicate = function(data, filter: string): boolean {
  //     let date = new Date(data.fecha);
  //     return data.nombre.toLowerCase().includes(filter) 
  //     ||  data.assessmentName.toLowerCase().includes(filter)
  //     ||  data.userNombre.toLowerCase().includes(filter)
  //     ||  data.puntuacion.toString().concat("%").includes(filter)
  //     ||  (data.notasEvaluacion != null && data.notasEvaluacion.toLowerCase().includes(filter))
  //     ||  (data.notasObjetivos != null && data.notasObjetivos.toLowerCase().includes(filter))
  //     ||  ((date.getDate()<10?"0":"")+date.getDate()+"/"+(date.getMonth()<10?"0":"")+(date.getMonth()+1)+"/"+date.getFullYear()).includes(filter)
  //     ;
  //  };
  }

  applyFilter(filterValue: string){
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }


  public parseDate(value: string): string{
    let date = new Date(value);
    console.log(date.getDay()+"/"+date.getMonth()+"/"+date.getFullYear());
    return date.getDay()+"/"+date.getMonth()+1+"/"+date.getFullYear();
  }

  checkRespuestaCorrecta(row): string {
    //Pregunta correcta == null --> Si (habilitante)
    //Pregunta correcta != null --> Si o No
    

    let classString: string;
    let respuestaString: string = this.displayRespuesta(row);


    //Si (habilitante)
    if (row.correcta == null) {
      //Contestado -> Si
      switch (row.estado) {
        case 0:
          classString = "respuesta-no-contestada";
          break
        case 1:
          classString = "respuesta-correcta";
          break
        case 2:
          classString = "respuesta-incorrecta";
          break
      }
    } else {
      if (respuestaString == row.correcta) {
        classString = "respuesta-correcta";
      } else {
        //No contestada
        if (row.estado == 0) {
          classString = "respuesta-no-contestada";
        } else {
          classString = "respuesta-incorrecta";
        }
      }
    }


    return classString;
  }

  displayRespuesta(row: RespuestaConNotasTabla): string {
    let respuesta: string = "";
    switch (row.estado) {
      case 0:
        respuesta = "NC";
        break
      case 1:
        respuesta = "Si";
        break;
      case 2:
        respuesta = "No";
        break;

      default:
        break;
    }
    return respuesta;
  }
  
  constructor(
    private _appComponent: AppComponent
    ){
    }



}
