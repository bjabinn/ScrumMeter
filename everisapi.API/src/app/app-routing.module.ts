import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from '@angular/core';

import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { MenunewevaluationComponent } from './menunewevaluation/menunewevaluation.component';
import { NewevaluationComponent } from './newevaluation/newevaluation.component';
import { PreviousevaluationComponent } from './previousevaluation/previousevaluation.component';
import { PdfgeneratorComponent } from './pdfgenerator/pdfgenerator.component';
import { BackOfficeComponent } from './back-office/back-office.component';
import { UserManagementComponent } from './back-office/components/user-management/user-management.component';
import { AddUserProjectComponent } from './back-office/components/add-user-project/add-user-project.component';
import { QuestionsManagerComponent } from './back-office/components/questions-manager/questions-manager.component';

const appRoutes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'login', component: LoginComponent },
  { path: 'home', component: HomeComponent },
  {
    path: 'backoffice', component: BackOfficeComponent,
    children: [
      { path: 'usermanagement', component: UserManagementComponent },
      { path: 'adduserproject', component: AddUserProjectComponent },
      { path: 'questions', component: QuestionsManagerComponent }
    ]
  },
  { path: 'menunuevaevaluacion', component: MenunewevaluationComponent },
  { path: 'nuevaevaluacion', component: NewevaluationComponent },
  { path: 'pdfgenerator', component: PdfgeneratorComponent },
  { path: 'evaluacionprevia', component: PreviousevaluationComponent },
  { path: '**', component: LoginComponent }

];

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  exports: [RouterModule]
})
export class AppRoutingModule { }

export const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);


