import { Component } from '@angular/core';
import { AdminService } from "../../services/admin.service";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {
  listOfTasks: any[] = [];

  constructor(private service: AdminService) {
    this.getTasks();
  }

  getTasks() {
    this.service.getAllTasks().subscribe((res) => {
      this.listOfTasks = res;
    });
  }
}
