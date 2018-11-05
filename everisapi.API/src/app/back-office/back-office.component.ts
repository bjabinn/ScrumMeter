import { Component, OnInit } from '@angular/core';
import { Router } from "@angular/router";
import { AppComponent } from '../app.component';
import { ProyectoService } from '../services/ProyectoService';

@Component({
  selector: 'app-back-office',
  templateUrl: './back-office.component.html',
  styleUrls: ['./back-office.component.scss'],
  providers: [ProyectoService]
})


export class BackOfficeComponent implements OnInit {

  //public AdminOn = false;

  constructor(
    private _proyectoService: ProyectoService,
    private _router: Router,
    private _appComponent: AppComponent) { }
    

  ngOnInit() {

    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }

    

  }

}
