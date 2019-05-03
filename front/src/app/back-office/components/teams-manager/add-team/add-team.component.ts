import { Proyecto } from './../../../../Models/Proyecto';
import { Component, OnInit } from '@angular/core';
import { ProyectoService } from 'app/services/ProyectoService';
import { Router, ActivatedRoute } from '@angular/router';
import { EventEmitterService } from 'app/services/event-emitter.service';
import { AppComponent } from 'app/app.component';
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import { Office } from 'app/Models/Office';
import { Unity } from 'app/Models/Unit';
import { Linea } from 'app/Models/Linea';
import { User } from 'app/Models/User';



@Component({
  selector: 'app-add-team',
  templateUrl: './add-team.component.html',
  styleUrls: ['./add-team.component.scss']
})
export class AddTeamComponent implements OnInit { 
 public updateUser: string = null;
 public addTeamsForm: FormGroup; 
 
 public officeList : Office[]; 
 public unityList : Unity[];
 public lineaList : Linea[];
 public UserNombre : User;
 public ErrorMessage: string = null;
 public idEquipo:number = 0;
 public equipo:Proyecto;

 constructor(   //ProyectoService its teams service --> table proyectos its teams in DataBase
   private _teamsService: ProyectoService, 
   public _router: Router,
   private _eventService: EventEmitterService, 
   private _appComponent: AppComponent,
   private _routeParams : ActivatedRoute,
   fb: FormBuilder) {
     this._eventService.eventEmitter.subscribe(
       (data) => {
           this.updateUser= data,
           setTimeout(()=>{this.updateUser = null},2000)
       }
       );
       this.addTeamsForm = fb.group({
        hideRequired: false,
        floatLabel: 'auto',
      });
  }

 ngOnInit(){
   this.getEquipo();
   // if user not login --> redirect to login
   if (!this._teamsService.verificarUsuario()) {
     this._router.navigate(['/login']);
   }
   this.getUserNombre(); 
   this.getAllOficinas(); 
   this.formValidate();  
 }// end onInit

  public formValidate(){//form validate   
    this.addTeamsForm = new FormGroup({
      UserNombre : new FormControl(this.UserNombre.nombre), 
      OficinaEntity: new FormControl('', Validators.required), //officina     
      UnidadEntity: new FormControl('',Validators.required),//unidad
      LineaEntity: new FormControl('', Validators.required),//linea
      Nombre: new FormControl('', Validators.required),//team
      ProjectSize: new FormControl('', [Validators.pattern('[0-9 ]*'),Validators.required,Validators.min(0)]) 
    }); 
  }

  public getAllOficinas(){
    //retur all oficinas 
    this._teamsService.getAllOficinas().subscribe(
      res => {
        this.officeList = res;            
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " Oficinas List Not Found.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });  
  }
  public getUserNombre(){
    this.UserNombre = new User(localStorage.getItem("user"));    
  }

  public getAllUnidadesDe(oficina){
    //limpiar el campo que hubiera en unit
    this.addTeamsForm.removeControl('UnidadEntity');
    this.addTeamsForm.addControl('UnidadEntity',new FormControl('',Validators.required));
    //limpiamos el campo que hubiera en linea
    this.addTeamsForm.removeControl('LineaEntity');
    this.addTeamsForm.addControl('LineaEntity',new FormControl('',Validators.required));
    //console.log(oficina);  
    //retur all unidades of a select oficina
    this._teamsService.getAllUnitDe(oficina).subscribe(
      res => {
        this.unityList = res;            
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " Unidades List Not Found.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });
      
  }

  public getAllLineasDe(unidades){
    //limpiamos el campo que hubiera en linea
    this.addTeamsForm.removeControl('LineaEntity');
    this.addTeamsForm.addControl('LineaEntity',new FormControl('',Validators.required));
    //console.log(unidades);  
    //retur all unidades of a select oficina
    this._teamsService.getAllLineasDe(unidades).subscribe(
      res => {
        this.lineaList = res;            
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " Linea List Not Found.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
  });  
  }

  public altaEquipo(){  
   var form = this.addTeamsForm.value;
    this._teamsService.setTeam(form).subscribe(
      res => {
        this._router.navigate(['/backoffice/teamsmanager']);
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " Alta team Not Found.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }); 
  }

 //form validate
  public hasError = (controlName: string, errorName: string) =>{
    return this.addTeamsForm.controls[controlName].hasError(errorName);
  }

  public getEquipo(){
  this.idEquipo = this._routeParams.snapshot.params.idEquipo;   
  if(this.idEquipo != 0){   
    this._teamsService.getProyecto(this._routeParams.snapshot.params.idEquipo).subscribe(
      res => {       
        this.equipo = res;
        console.log(this.equipo);
      },
      error => {
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " No se pudo encontrar la información solicitada.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });
    }    
  }

  public updateEquipo(){
    var form = this.addTeamsForm.value;
    console.log(form);
    /*this._teamsService.setTeam(form).subscribe(
      res => {
        this._router.navigate(['/backoffice/teamsmanager']);
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " Alta team Not Found.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      }); 
  }*/
  }


}