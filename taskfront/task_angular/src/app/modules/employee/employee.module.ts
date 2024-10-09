import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { EmployeeRoutingModule } from './employee-routing.module';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {DemoAngularMaterialModule} from "../../DemoAngularMaterialModule";
import {DashboardComponent} from "./components/dashboard/dashboard.component";



@NgModule({
  declarations: [
    DashboardComponent
  ],
  imports: [
    CommonModule,
    EmployeeRoutingModule,
    HttpClientModule,
    ReactiveFormsModule,
    FormsModule,
    DemoAngularMaterialModule
  ]
})
export class EmployeeModule { }
