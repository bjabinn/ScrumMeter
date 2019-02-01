import { Component, OnInit, ViewChild } from '@angular/core';
import { MatSort, MatTableDataSource, MatPaginator } from '@angular/material';
import { AppComponent } from 'app/app.component';

//DATOS DE EJEMPLO///////////////////////////////////
export interface PeriodicElement {
  office: string;
  unity: string;
  project: string;
  team: string;
}

const ELEMENT_DATA: PeriodicElement[] = [
  {office: '1', unity: 'proyecto', project: '1.0079', team: 'H'},
  {office: '2', unity: 'proyecto', project: '4.0026', team: 'He'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
  {office: '3', unity: 'proyecto', project: '6.941', team: 'Li'},
];
//DATOS DE EJEMPLO///////////////////////////////////


@Component({
  selector: 'app-teams-manager',
  templateUrl: './teams-manager.component.html',
  styleUrls: ['./teams-manager.component.scss']
})
export class TeamsManagerComponent implements OnInit {

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  _appComponent: AppComponent;
  // userRole;
  dataInput = ELEMENT_DATA;
  dataSource;
  displayedColumns = ['office', 'unity', 'project', "team", "size"];

  constructor() { }

  ngOnInit() {
    // this.userRole = this._appComponent._storageDataService.Role;
    this.dataSource = new MatTableDataSource(this.dataInput);
    this.dataSource.sort= this.sort;
    this.dataSource.paginator = this.paginator;
  }

}
