import { Component, OnInit } from '@angular/core';
import { StorageDataService } from './services/StorageDataService';
import { Http } from '@angular/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  providers: [StorageDataService]
})
export class AppComponent {

  constructor(
    public _storageDataService: StorageDataService,
    private _router: Router) {
  }


  public ComprobarUserYToken() {
    //Recogemos los datos
    var Token = this._storageDataService.TokenUser;
    var User = this._storageDataService.UserData;
    var TokenStorage = localStorage.getItem("tokenuser");
    var UserStorage = { 'nombre': localStorage.getItem("user"), 'password': localStorage.getItem("passuser") }

    //Recoger del localstorage tambien

    //Si no tiene nada nos devuelve a login sino nos da el token
    if (Token == null || Token == undefined || User == null || User == undefined || Token == "" || User.nombre == "" || User.password == "") {
      TokenStorage = localStorage.getItem("tokenuser");
      UserStorage = { 'nombre': localStorage.getItem("user"), 'password': localStorage.getItem("passuser") };
      if (TokenStorage == null || TokenStorage == undefined || UserStorage == null || UserStorage == undefined || TokenStorage == "" || UserStorage.nombre == "" || UserStorage.password == "") {
        this._router.navigate(["/login"]);
      } else {
        return "Bearer " + TokenStorage;
      }
    } else {
      return "Bearer " + this._storageDataService.TokenUser;
    }
  }
}
