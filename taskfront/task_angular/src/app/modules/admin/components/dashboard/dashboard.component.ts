import { Component, OnInit } from '@angular/core';
import { AdminService } from "../../services/admin.service";
import { MatSnackBar } from "@angular/material/snack-bar";
import { FormBuilder, FormGroup } from "@angular/forms";
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  listOfTasks: any[] = [];
  searchForm!: FormGroup;

  constructor(
    private service: AdminService,
    private snackBar: MatSnackBar,
    private fb: FormBuilder
  ) {
    this.searchForm = this.fb.group({
      title: ['']
    });
  }

  ngOnInit() {
    this.getTasks();
    this.setupSearchListener();
  }

  setupSearchListener() {
    this.searchForm.get('title')!.valueChanges
      .pipe(
        debounceTime(300),
        distinctUntilChanged()
      )
      .subscribe(searchTerm => {
        if (searchTerm && searchTerm.trim() !== '') {
          this.searchTask(searchTerm);
        } else {
          this.getTasks();
        }
      });
  }

  getTasks() {
    this.service.getAllTasks().subscribe(
      (res) => {
        this.listOfTasks = res;
      },
      (error) => {
        console.error('Error fetching tasks:', error);
        this.snackBar.open("Error fetching tasks", "Close", { duration: 5000 });
      }
    );
  }

  deleteTask(id: number) {
    this.service.deleteTask(id).subscribe(
      () => {
        this.snackBar.open("Task deleted successfully", "Close", { duration: 5000 });
        this.getTasks();
      },
      (error) => {
        console.error('Error deleting task:', error);
        this.snackBar.open("Error deleting task", "Close", { duration: 5000 });
      }
    );
  }

  searchTask(title: string) {
    this.service.searchTask(title).subscribe(
      (res) => {
        this.listOfTasks = res;
        console.log(res);
      },
      (error) => {
        console.error('Error searching tasks:', error);
        this.snackBar.open("Error searching tasks", "Close", { duration: 5000 });
      }
    );
  }
}
