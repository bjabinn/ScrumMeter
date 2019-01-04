import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { MatPaginator, MatSort, MatTableDataSource, MatCellDef } from '@angular/material';
import {animate, state, style, transition, trigger} from '@angular/animations';
import { Router } from "@angular/router";
import { AppComponent } from 'app/app.component';
import { EvaluacionInfoWithProgress } from 'app/Models/EvaluacionInfoWithProgress';
import { EvaluacionService } from '../../services/EvaluacionService';
import { SectionService } from 'app/services/SectionService';
import { AssignationService } from 'app/services/AssignationService';



@Component({
  selector: 'pendingevaluation-table',
  templateUrl: './pendingevaluation-table.component.html',
  styleUrls: ['./pendingevaluation-table.component.scss'],
  animations: [
    trigger('detailExpand', [
    state('collapsed, void', style({ height: '0px', minHeight: '0', display: 'none' })),
    state('expanded', style({ height: '*' })),
    transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    transition('expanded <=> void', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)'))
    ]),
  ],
})

export class PendingEvaluationTableComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @Input() dataInput: any;//Array<EvaluacionInfo>;
  public ErrorMessage: string = null;
  dataSource: MatTableDataSource<EvaluacionInfoWithProgress>;
  userRole: string;
  //expandedElement: Evaluacion;
  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = ['fecha', 'userNombre', 'assessmentName', 'progress', 'actions'];

  constructor(
    private _evaluacionService: EvaluacionService,
    private _assignationService: AssignationService,
    private _sectionService: SectionService,
    private _router: Router,
    private _appComponent: AppComponent
    ){
    }

  ngOnInit() {
    this.dataSource = new MatTableDataSource(this.dataInput);
    this.dataSource.sort= this.sort;
    this.dataSource.paginator = this.paginator;
    this.userRole = this._appComponent._storageDataService.Role;
    
    this.dataSource.filterPredicate = function(data, filter: string): boolean {
      let date = new Date(data.fecha);
      return data.nombre.toLowerCase().includes(filter) 
      ||  data.assessmentName.toLowerCase().includes(filter)
      ||  (data.userNombre != null && data.userNombre.toLowerCase().includes(filter) )
      ||  (data.progress != null && data.progress.toString().includes(filter))
      ||  ((date.getDate()<10?"0":"")+date.getDate()+"/"+(date.getMonth()<10?"0":"")+(date.getMonth()+1)+"/"+date.getFullYear()).includes(filter)
      ;
   };
  }

  applyFilter(filterValue: string){
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  public parseDate(value: string): string{
    let date = new Date(value);
    return date.getDay()+"/"+date.getMonth()+1+"/"+date.getFullYear();
  }

  //Metodo encargado de establecer la información de la evaluacion en StorageData
  public GetEvaluation(evaluation: EvaluacionInfoWithProgress){
    this._evaluacionService.getEvaluacion(evaluation.id).subscribe(
      res => {
        this._appComponent._storageDataService.Evaluacion = res;
        this._appComponent._storageDataService.AssessmentSelected = {'assessmentId': evaluation.assessmentId, 'assessmentName': undefined};
        this.GetAssignation(evaluation.id, evaluation.assessmentId);
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " No se pudo encontrar la evaluación solicitada.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }
      );
  }
  
  //Metodo encargado de establecer la información necesaria de la seccion en StorageData
  public GetSectionInfo(evaluationId: number, sectionId: number){
    this._sectionService.GetSectionsInfoFromSectionId(evaluationId, sectionId).subscribe(
      res => {
        this._appComponent._storageDataService.SectionSelectedInfo = res;
        this._router.navigate(['/nuevaevaluacion']);  
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " No se pudo encontrar la sección solicitada.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }
      );
  }

  //Metodo encargado de establecer la información de la asignacion en StorageData
  public GetAssignation(evaluationId: number, assesmentId: number){
    this._assignationService.AssignationFirstUnansweredQuestion(evaluationId, assesmentId).subscribe(
      res => {
        console.log ("elres: " + assesmentId);
        console.log ("elres: " + evaluationId);
        console.log ("elres: " + res.sectionId);
        console.log ("Asignacion: " + res.id);
        this._appComponent._storageDataService.currentAssignation = res;
        this.GetSectionInfo(evaluationId, res.sectionId);
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " No se pudo encontrar la asignación solicitada.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }
      );

  }

  public ContinueEvaluation(evaluation: EvaluacionInfoWithProgress){
    this.GetEvaluation(evaluation);
  }
}
