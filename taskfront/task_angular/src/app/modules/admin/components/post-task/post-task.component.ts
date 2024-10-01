import { Component } from '@angular/core';
import {AdminService} from "../../services/admin.service";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";

@Component({
  selector: 'app-post-task',
  templateUrl: './post-task.component.html',
  styleUrls: ['./post-task.component.scss']
})
export class PostTaskComponent {

   taskForm!: FormGroup;
   listofEmployees:any=[];
   listofPriorities:any=["LOW","MEDIUM","HIGH"];

  constructor(private adminService: AdminService,
              private fb: FormBuilder) {
    this.getUsers();
    this.taskForm = this.fb.group({
      employeeId:[null, Validators.required],
      title:[null, Validators.required],
      description:[null, Validators.required],
      dueDate:[null, Validators.required],
      priority:[null, Validators.required],

    })
  }

  getUsers(){
    this.adminService.getUsers().subscribe((res)=>{
      this.listofEmployees = res;
      console.log(res);
    })
  }

  postTask(){
    console.log(this.taskForm.value);
  }

}
