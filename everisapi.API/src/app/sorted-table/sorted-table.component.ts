import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import {animate, state, style, transition, trigger} from '@angular/animations';
import{PreviousevaluationComponent} from 'app/previousevaluation/previousevaluation.component'
export interface Evaluacion {
  id: number,
  fecha: string;
  nombre: string,
  userNombre: string;
  puntuacion: number;
  estado: boolean;
  notasEv: string;
  notasOb: string;
}

@Component({
  selector: 'sorted-table',
  templateUrl: './sorted-table.component.html',
  styleUrls: ['./sorted-table.component.css'],
  animations: [
    trigger('detailExpand', [
    state('collapsed, void', style({ height: '0px', minHeight: '0', display: 'none' })),
    state('expanded', style({ height: '*' })),
    transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    transition('expanded <=> void', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)'))
    ]),
  ],
})

export class SortedTableComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @Input() dataInput: any;//Array<EvaluacionInfo>;
  dataSource: MatTableDataSource<Evaluacion>;
  //isExpansionDetailRow = (i: number, row: Object) => row.hasOwnProperty('fecha');
  expandedElement: Evaluacion;
  /** Columns displayed in the table. Columns IDs can be added, removed, or reordered. */
  displayedColumns = ['fecha', 'usuario', 'metodologia', 'puntuacion', 'estado', 'notas', 'informe'];

  ngOnInit() {
    //console.log(this.dataSource);   
    this.dataSource = new MatTableDataSource(this.dataInput);
    this.dataSource.sort= this.sort;
    this.dataSource.paginator = this.paginator;
    /*const rows = [];
    this.dataSource.data.forEach(element => rows.push(element, { detailRow: true, element }));
    this.dataSource.data = rows;*/
  }

  applyFilter(filterValue: string){
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }
  
  constructor(private prevEval: PreviousevaluationComponent){}

  SaveDataToPDF(evaluacion: EvaluacionInfo): void {
    this.prevEval.SaveDataToPDF(evaluacion) ;
  }
}
