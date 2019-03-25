
import { Injectable, Inject } from '@angular/core';
import { User } from 'app/Models/User';
import { Evaluacion } from 'app/Models/Evaluacion';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { Section } from 'app/Models/Section';
import { SectionInfo } from 'app/Models/SectionInfo';
import { Observable ,  Subscription } from 'rxjs';
import { setTimeout } from 'timers';
import { ProyectoService } from 'app/services/ProyectoService';
import { AppComponent } from 'app/app.component';
import { Router } from "@angular/router";
import { Assessment } from '../Models/Assessment';
import { Asignacion } from 'app/Models/Asignacion';


@Injectable()
export class StorageDataService {
  public UserProjects: any = [];
  public UserProjectSelected: Proyecto = { id: -1, fecha: null, nombre: '', numFinishedEvals:0, numPendingEvals: 0 };
  public UserData: User;
  public DataUnfinished: boolean = false;
  public SectionSelected: Section = null;
  public SectionSelectedInfo: SectionInfo = null;
  public Evaluacion: Evaluacion = null;
  public EvaluacionToPDF: EvaluacionInfo = null;
  public SectionName: string = null;
  public TokenUser: string = "";
  public UserLongName: string = "";
  public subscriptionTimer: Subscription;
  public AssessmentSelected: Assessment = null;
  public RoleAdmin: boolean;
  public Role: string;
  public nextSection : SectionInfo = null;
  public prevSection : SectionInfo = null;
  public Sections: SectionInfo[] = [];
  public currentAssignation: Asignacion = { 'id': 0, 'nombre': "undefined" };
  public breadcrumbList: Array<any> = [];


  public GetToken() {
    if (this.TokenUser == null || this.TokenUser == undefined || this.TokenUser == "") {
      let token = localStorage.getItem("tokenuser");
      if (token == null || token == undefined || token == "") {
        return null;
      } else {
        return token;
      }
    } else {
      return this.TokenUser;
    }
  }

  public GetUser() {
    
    if (this.TokenUser == null || this.TokenUser == undefined || this.TokenUser == "") {
      let token = localStorage.getItem("tokenuser");
      if (token == null || token == undefined || token == "") {
        return null;
      } else {
        return this.UserData;
      }
    } else {
      return { 'nombre': localStorage.getItem('user'), 'password': localStorage.getItem('passuser') };
    }
  }

 

  public RefreshToken(NewToken: string) {
    if (this.TokenUser == null || this.TokenUser == undefined || this.TokenUser == "") {
      let token = localStorage.getItem("tokenuser");
      if (token == null || token == undefined || token == "") {
        localStorage.removeItem("tokenuser");
        this.TokenUser = null;
      } else {
        localStorage.setItem("tokenuser", NewToken);
      }
    } else {
      this.TokenUser = NewToken;
    }
  }
}
