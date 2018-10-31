import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/UserService';
import { User } from 'app/Models/User';

@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss'],
  providers: [UserService]
})
export class UserManagementComponent implements OnInit {

  // elements: any = [];
  // headElements = ['ID', 'First', 'Last', 'Handle'];

  // searchText: string = '';
  // previous: string;
  
  public ListaDeUsuarios: Array<User> = [];
  constructor(private _UserService: UserService) { }

  //@HostListener('input') 
  // oninput() {
  //   this.searchItems();
  // }

  ngOnInit() {
    //for (let i = 1; i <= 10; i++) {
      //this.elements.push({ id: i.toString(), first: 'Wpis ' + i, last: 'Last ' + i, handle: 'Handle ' + i });
      this.searchItems();
    }

    //this._UserService.setDataSource(this.elements);
    //this.elements = this._UserService.getUsers();
    //this.previous = this._UserService.getUsers();
  

  public searchItems() {
     //this.usuarios = this._UserService.getUsers();

     this._UserService.getUsers().subscribe(
      res => {
        console.log(res);
        this.ListaDeUsuarios = res;
        console.log(this.ListaDeUsuarios);
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        console.log('explotido');
      });

     
  }

    // if (!this.searchText) {
    //   this._UserService.setDataSource(this.previous);
    //   this.elements = this._UserService.getUsers();
    // }

    // if (this.searchText) {
    //   this.elements = this._UserService.searchLocalDataBy(this.searchText);
    //   this._UserService.setDataSource(prev);
    // }

  

}
