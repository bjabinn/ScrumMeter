import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { MatSort, MatTableDataSource } from '@angular/material';
import { AppComponent } from 'app/app.component';
import { RespuestaConNotas } from 'app/Models/RespuestaConNotas';
import { RespuestaConNotasTabla } from 'app/pdfgenerator/pdfgenerator.component';
import { RespuestasService } from 'app/services/RespuestasService';
import { Respuesta } from 'app/Models/Respuesta';
import { s } from '@angular/core/src/render3';
import { stringify } from '@angular/compiler/src/util';

@Component({
  selector: 'app-section-results',
  templateUrl: './section-results.component.html',
  styleUrls: ['./section-results.component.scss']
})
export class SectionResultsComponent implements OnInit {

  @ViewChild(MatSort) sort: MatSort;
  @Input() lSectionConAsignacionesDto: any; //IEnumerable<SectionConAsignacionesDto>
  userRole: string = this._appComponent._storageDataService.Role;
  dataSource: MatTableDataSource<any>;
  expandedElement: RespuestaConNotas;
  returnedNote: string = "";

  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = ['pregunta', 'estado', 'notas'];
  
  constructor(
    private _appComponent: AppComponent,
    private _respuestasService: RespuestasService
    ){
    }
    saveNotas(model: RespuestaConNotas): void{
      let answer: Respuesta  = new Respuesta(model.id, model.estado, 0, 0, model.notas, model.notasAdmin);
      if(this.userRole == "Administrador" || this.userRole == "Evaluador"){
        this._respuestasService.AlterRespuesta(answer).subscribe();
      }
    }

  ngOnInit() {
  }
  
  //Metodo para dar formato a la fecha introducida
  public parseDate(value: string): string{
    let date = new Date(value);
    console.log(date.getDay()+"/"+date.getMonth()+"/"+date.getFullYear());
    return date.getDay()+"/"+date.getMonth()+1+"/"+date.getFullYear();
  }

  //Metodo encargado de formar la tabla de preguntas para cada modulo
  public CreateQuestionsTable(lQuestions){
    this.dataSource = new MatTableDataSource(lQuestions.filter(x => x.estado != 0));
    this.dataSource.sort= this.sort;
    this.dataSource.sortingDataAccessor = (data: any, sortHeaderId: string): string => {
      if (sortHeaderId == "estado") {
        if(data[sortHeaderId] == "0"){
          return "2";
        }
        else if((data[sortHeaderId] == "1" && data["correcta"]=="Si") || (data[sortHeaderId] == "2" && data["correcta"]=="No") || data["correcta"]== null){
          return "1";
        }
        else{
          return "3";
        }
      } 
      return data[sortHeaderId];
    };
    return this.dataSource;
  }

  public checkRespuestaCorrecta(row): string {
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
}
