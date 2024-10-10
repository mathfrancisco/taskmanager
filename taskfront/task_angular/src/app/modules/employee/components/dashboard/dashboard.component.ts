import { Component, OnInit } from '@angular/core';
import { EmployeeService } from "../../services/employee.service";
import {MatSnackBar} from "@angular/material/snack-bar";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  listOfTasks: any = [];

  constructor(private service: EmployeeService,
              private snackbar: MatSnackBar) {}

  ngOnInit() {
    this.getTasks();
  }

  getTasks() {
    this.service.getEmployeeTasksById().subscribe((res) => {
      console.log(res);
      this.listOfTasks = res;
    });
  }

  updateStatus(id:number,status:string){
    this.service.updateStatus(id,status).subscribe((res)=>{
      if(res.id!=null){
        this.snackbar.open("Task Updated Successfully!","Close",{duration:5000});
        this.getTasks();
      }else {
        this.snackbar.open("Getting error while updating task!","Close",{duration:5000});
      }
    })

  }
}
