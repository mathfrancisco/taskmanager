import { Component, OnInit } from '@angular/core';
import { AdminService } from "../../services/admin.service";
import { ActivatedRoute } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { MatSnackBar } from "@angular/material/snack-bar";

@Component({
  selector: 'app-view-task-details',
  templateUrl: './view-task-details.component.html',
  styleUrls: ['./view-task-details.component.scss']
})
export class ViewTaskDetailsComponent implements OnInit {
  taskId: number = this.activatedRoute.snapshot.params['id'];
  taskData: any;
  comments: any[] = [];
  commentForm!: FormGroup;


  constructor(
    private adminService: AdminService,
    private activatedRoute: ActivatedRoute,
    private fb: FormBuilder,
    private snackbar: MatSnackBar
  ) {}

  ngOnInit() {
    this.getTasksById();
    this.getComments();
    this.commentForm = this.fb.group({
      content: [null, Validators.required]
    });
  }

  getTasksById() {
    this.adminService.getTaskById(this.taskId).subscribe((res) => {
      this.taskData = res;
    });
  }

  publishComment() {
    this.adminService.createComment(this.taskId, this.commentForm.get("content")?.value).subscribe(
      (res) => {
        if (res.id != null) {
          this.snackbar.open("Comment created successfully", "Close", { duration: 5000 });
          this.getComments();
          this.commentForm.reset(); // Reset the form after successful submission
        } else {
          this.snackbar.open("Something went wrong", "ERROR", { duration: 5000 });
        }
      },
      (error) => {
        console.error('Error publishing comment:', error);
        this.snackbar.open("Error publishing comment", "ERROR", { duration: 5000 });
      }
    );
  }

  getComments() {
    this.adminService.getCommentsByTask(this.taskId).subscribe(
      (res) => {
        this.comments = res.map((comment: any) => ({
          ...comment,
          content: this.parseCommentContent(comment.content)
        }));
      },
      (error) => {
        console.error('Error fetching comments:', error);
        this.snackbar.open("Error fetching comments", "ERROR", { duration: 5000 });
      }
    );
  }

  parseCommentContent(content: string): string {
    try {
      const parsed = JSON.parse(content);
      return typeof parsed === 'object' ? parsed.content || content : content;
    } catch (e) {
      return content;
    }
  }
}
