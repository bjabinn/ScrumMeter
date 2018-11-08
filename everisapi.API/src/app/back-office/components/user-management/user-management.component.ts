import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
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
  public radioSelected;
  public rolControl;
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
  public filteredProjects: ReplaySubject<Proyecto[]> = new ReplaySubject<Proyecto[]>(1);

  /** list of banks filtered by search keyword for multi-selection */
  public filteredProjectsMulti: ReplaySubject<Proyecto[]> = new ReplaySubject<Proyecto[]>(1);

  @ViewChild('singleSelect') singleSelect: MatSelect;
  @ViewChild('multiSelect') multiSelect: MatSelect;

  private _onDestroy = new Subject<void>();
  
  constructor(
    private _UserService: UserService, 
    private _proyectoService: ProyectoService,
    private _router: Router,
    private _appComponent: AppComponent
    ){ }

  ngOnInit() {
    //Empezamos cargando el usuario en el componente mientras verificamos si esta logueado
    //En casao de no estar logeado nos enviara devuelta al login
    if (!this._proyectoService.verificarUsuario()) {
      this._router.navigate(['/login']);
    }
    this.getAllUsers();
    this.getAllRoles();
    this.getAllProjects();

    this.radioSelected = this.ListaDeRoles[0];


    //listen for search field value changes
    this.userFilterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterUsers();
      });

    this.projectMultiFilterCtrl.valueChanges
    .pipe(takeUntil(this._onDestroy))
    .subscribe(() => {
      this.filterProjectMulti();
    });  

    }

    ngAfterViewInit() {
    // this.setInitialValue();     
    }
  
    ngOnDestroy() {
      this._onDestroy.next();
      this._onDestroy.complete();
    }  


  // private setInitialValue() {
  //     this.filteredUsers
  //       .pipe(take(1), takeUntil(this._onDestroy))
  //       .subscribe(() => {
  //         // setting the compareWith property to a comparison function
  //         // triggers initializing the selection according to the initial value of
  //         // the form control (i.e. _initializeSelection())
  //         // this needs to be done after the filteredBanks are loaded initially
  //         // and after the mat-option elements are available
  //         this.singleSelect.compareWith = (a: UserWithRole, b: UserWithRole) => a.nombre === b.nombre;
  //         this.multiSelect.compareWith = (a: UserWithRole, b: UserWithRole) => a.nombre === b.nombre;
  //       });
  //   }  

  public getAllUsers(){

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

  public getAllRoles(){

    this._UserService.getAllRoles().subscribe(
     res => {this.ListaDeRoles = res; 
       console.log(this.ListaDeRoles);
     }
     ,
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

 public getAllProjects(){
  
  
  this._proyectoService.getAllProyectos().subscribe(
    res => {
      
      this.ListaDeProyectos = res;
      console.log(this.ListaDeProyectos);
      console.log("lista de proyectos",this.ListaDeProyectos);
      this.projectMultiCtrl.setValue([this.ListaDeProyectos[1], this.ListaDeProyectos[2], this.ListaDeProyectos[3]]);
      this.filteredProjectsMulti.next(this.ListaDeProyectos.slice());
      
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

  public SeleccionDeUsuario(index: number) {
    console.log("usuario",this.userCtrl.value);
    
    //this.userCtrl.setValue(this.ListaDeUsuarios[index]);

    this.UsuarioSeleccionado = this.ListaDeUsuarios[index];

    this.radioSelected = this.userCtrl.value;
    
  }

  public SeleccionDeRol(){
    
    console.log("rolControl", this.rolControl);
    // = this.rolControl;
    this.userCtrl.value.role = this.rolControl;
    //this.UsuarioSeleccionado.role = this.radioSelected;
    console.log("userCtrl",this.userCtrl.value.role.id);
    
  }

  // public SeleccionDeUsuario(index: number) {
  //   console.log("usuario",index);
    
  //   this.UsuarioSeleccionado = this.ListaDeUsuarios[index];

  //   this.radioSelected = this.UsuarioSeleccionado;

  //   console.log(this.UsuarioSeleccionado);
    
  // }

  // public SeleccionDeRol(){
    
  //   this.UsuarioSeleccionado.role = this.radioSelected;
  //   console.log("rol", this.radioSelected);
  // }


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
    // filter the banks
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
      this.filteredProjectsMulti.next(this.ListaDeProyectos.slice());
      return;
    } else {
      search = search.toLowerCase();
    }
    // filter the banks
    this.filteredProjectsMulti.next(
      this.ListaDeProyectos.filter(project => project.nombre.toLowerCase().indexOf(search) > -1)
    );
  }
  

}
