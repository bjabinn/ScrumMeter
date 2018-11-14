import { Component, OnInit, OnDestroy, ViewChild, NgZone } from '@angular/core';
import { UserService } from '../../../services/UserService';
import { ProyectoService } from 'app/services/ProyectoService';
import { Router } from "@angular/router";
import { UserWithRole } from 'app/Models/UserWithRole';
import { Proyecto } from 'app/Models/Proyecto';
import { AppComponent } from 'app/app.component';
import { Role } from 'app/Models/Role';
import { FormControl } from '@angular/forms';
import { take, takeUntil } from 'rxjs/operators';
import { Subject } from 'rxjs';
import { ReplaySubject } from 'rxjs';
import { MatSelect, VERSION } from '@angular/material';
import { User } from 'app/Models/User';


@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss'],
  providers: [UserService, ProyectoService]
})


export class UserManagementComponent implements OnInit {

  public ErrorMessage: string = null;
  public ListaDeUsuarios: UserWithRole[] = [];
  public UsuarioSeleccionado: UserWithRole;
  public ListaDeRoles: Role[] = [];
  public ListaDeProyectos: Proyecto[] = [];
  public ListaDeProyectosUsuario: Proyecto[] = [];
  public radioSelected;
  public rolControl;
  public showProjects:boolean = false;

  public projectsSelected: string[] = [];
  /** control for the selected bank */
  public userCtrl: FormControl = new FormControl();

  /** control for the MatSelect filter keyword */
  public userFilterCtrl: FormControl = new FormControl();
  /** control for the selected bank for multi-selection */
  public projectMultiCtrl: FormControl = new FormControl();

  /** control for the MatSelect filter keyword multi-selection */
  public projectMultiFilterCtrl: FormControl = new FormControl();


  /** list of banks filtered by search keyword */
  public filteredUsers: ReplaySubject<UserWithRole[]> = new ReplaySubject<UserWithRole[]>(1);
  //public filteredProjects: ReplaySubject<Proyecto[]> = new ReplaySubject<Proyecto[]>(1);

  /** list of banks filtered by search keyword for multi-selection */
  public filteredProjectsMulti: ReplaySubject<Proyecto[]> = new ReplaySubject<Proyecto[]>(1);
  public selected: string[] = ["BCA"];

  private _onDestroy = new Subject<void>();
  obj;
  constructor(
    private _UserService: UserService,
    private _proyectoService: ProyectoService,
    private _router: Router,
    private _appComponent: AppComponent,
    private _zone: NgZone
  ) {


  }

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }
    // this.getAllUsers();
    // this.getAllRoles();
    // this.getAllProjects();




    //listen for search field value changes
    this.userFilterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterUsers();

      });

    this.userCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.getUserProjects();
        this.filterProjectMulti();
        //this.filteredProjectsMulti.next(this.ListaDeProyectos.slice());

      });

    this.projectMultiFilterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterProjectMulti();
      });

    this.projectMultiCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        console.log("control", this.projectMultiCtrl.value);
        this.ListaDeProyectosUsuario = this.projectMultiCtrl.value;
      });



  }

  ngAfterViewInit() {
    // this.setInitialValue();
    this.getAllUsers();
    this.getAllRoles();
    this.getAllProjects();
    // setTimeout(()=>{
    //   this.obj = [{id: 3, nombre: "BestDay", fecha: "2018-07-10T00:00:00"}];
    //   console.log(this.projectMultiCtrl.value);

    // },3000);

  }

  ngOnDestroy() {
    this._onDestroy.next();
    this._onDestroy.complete();
  }


  private getAllUsers() {

    this._UserService.getUsers().subscribe(
      res => {
        this.ListaDeUsuarios = res;
        this.filteredUsers.next(this.ListaDeUsuarios.slice());
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });
  }

  private getAllRoles() {

    this._UserService.getAllRoles().subscribe(
      res => { this.ListaDeRoles = res; },
      error => {
        console.log("explota explota mi corazzon");
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });
  }

  private getAllProjects() {

    this._proyectoService.getAllProyectos().subscribe(
      res => {
        this.ListaDeProyectos = res;
        // this.projectMultiCtrl.setValue(this.ListaDeProyectos); 
        this.filteredProjectsMulti.next(this.ListaDeProyectos);
      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
      });

  }

  public seleccionDeRol() {

    //console.log("rolControl", this.rolControl);
    // = this.rolControl;
    this.userCtrl.value.role = this.rolControl;
    //this.UsuarioSeleccionado.role = this.radioSelected;
    //console.log("userCtrl",this.userCtrl.value.role.id);

  }

  private filterUsers() {
    if (!this.ListaDeUsuarios) {
      return;
    }
    // get the search keyword
    let search = this.userFilterCtrl.value;
    if (!search) {
      this.filteredUsers.next(this.ListaDeUsuarios.slice());
      return;
    } else {
      search = search.toLowerCase();
    }
    // filter the Users
    this.filteredUsers.next(
      this.ListaDeUsuarios.filter(user => user.nombre.toLowerCase().indexOf(search) > -1)
    );
  }

  private filterProjectMulti() {
    if (!this.ListaDeProyectos) {
      return;
    }
    // get the search keyword
    let search = this.projectMultiFilterCtrl.value;
    if (!search) {

      this.filteredProjectsMulti.next(this.ListaDeProyectos);
      //console.log(this.projectMultiCtrl.value);



      console.log(this.filteredProjectsMulti);

      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredProjectsMulti.next(
      this.ListaDeProyectos.filter(project => project.nombre.toLowerCase().indexOf(search) > -1)
    );
  }

  private getUserProjects() {

    this._proyectoService.getProyectosDeUsuarioSeleccionado(this.userCtrl.value).subscribe(
      res => {
        this.ListaDeProyectosUsuario = res;
        this.projectsSelected = [];
        console.log("lista de todos los proyectos", this.ListaDeProyectos);
        // console.log("control de proyectos value", this.projectMultiCtrl.value);
        console.log("proyectos del usuario:", this.userCtrl.value.nombre, this.ListaDeProyectosUsuario);

        //console.log(this.filteredProjectsMulti);

        
          this.ListaDeProyectosUsuario.forEach((element) => {
            this.projectsSelected.push(`${element.id}`);
            this.showProjects=true;
          });
        


        console.log(this.projectsSelected);


        //this.projectMultiCtrl.setValue(this.ListaDeProyectosUsuario);
        //console.log("control de proyectos de usuario value", this.projectMultiCtrl.value);



        //this.projectMultiCtrl.setValue(this.ListaDeProyectosUsuario);



        //this.filteredProjectsMulti.next(this.ListaDeProyectosUsuario);





      },
      error => {
        //Si el servidor tiene algún tipo de problema mostraremos este error
        if (error == 404) {
          this.ErrorMessage = "Error: " + error + " El usuario o proyecto autenticado no existe.";
        } else if (error == 500) {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        } else if (error == 401) {
          this.ErrorMessage = "Error: " + error + " El usuario es incorrecto o no tiene permisos, intente introducir su usuario nuevamente.";
        } else {
          this.ErrorMessage = "Error: " + error + " Ocurrio un error en el servidor, contacte con el servicio técnico.";
        }
        setTimeout(() => this.ErrorMessage = "", 2000);
      });

  }

  manageUserProjects(project){
    let exists:boolean = false;
    let i = 0;

    this.ListaDeProyectosUsuario.forEach((element,index)=>{
        if(element.id == project.id){exists=true;i=index;}
    });

    // let index = this.ListaDeProyectosUsuario.indexOf(project);
    // console.log(""+ project.id,index);
    // console.log("proyecto en lista de Usuario", this.ListaDeProyectosUsuario[index]);
    
    
    if(exists){
        this.ListaDeProyectosUsuario.splice(i,1);
    }else{
      this.ListaDeProyectosUsuario.push(project);
    }
  }


}
