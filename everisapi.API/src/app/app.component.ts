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


}
