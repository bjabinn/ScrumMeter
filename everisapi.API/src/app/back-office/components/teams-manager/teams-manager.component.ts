import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { MatSort, MatTableDataSource, MatPaginator } from '@angular/material';
import { AppComponent } from 'app/app.component';

@Component({
  selector: 'app-teams-manager',
  templateUrl: './teams-manager.component.html',
  styleUrls: ['./teams-manager.component.scss']
})
export class TeamsManagerComponent implements OnInit {

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  @Input() dataInput: any;
  _appComponent: AppComponent;
  // userRole;
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
