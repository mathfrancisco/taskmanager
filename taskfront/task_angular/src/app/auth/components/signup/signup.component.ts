import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { AuthService } from "../../services/auth/auth.service";
import { MatSnackBar } from "@angular/material/snack-bar";
import { Router } from "@angular/router";

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent {
  signupForm: FormGroup;
  hidePassword = true;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private snackbar: MatSnackBar,
    private router: Router
  ) {
    this.signupForm = this.fb.group({
      name: [null, [Validators.required]],
      email: [null, [Validators.required, Validators.email]],
      password: [null, [Validators.required]],
      confirmPassword: [null, [Validators.required]],
    });
  }

  togglePasswordVisibility() {
    this.hidePassword = !this.hidePassword;
  }

  onSubmit() {
    if (this.signupForm.valid) {
      const password = this.signupForm.get("password")?.value;
      const confirmPassword = this.signupForm.get("confirmPassword")?.value;

      if (password !== confirmPassword) {
        this.snackbar.open("Passwords do not match!", "Close", {
          duration: 5000,
          panelClass: "error-snackbar"
        });
        return;
      }

      this.authService.signup(this.signupForm.value).subscribe(
        (res) => {
          if (res.id != null) {
            this.snackbar.open(`Signup successful. Welcome, ${res.name}!`, "Close", { duration: 5000 });
            console.log("Attempting navigation to /login");
            this.router.navigateByUrl("/login").then(
              () => console.log("Navigation successful"),
              err => console.error("Navigation failed:", err)
            );
          } else {
            this.snackbar.open("Signup failed. Unexpected response format.", "Close", {
              duration: 5000,
              panelClass: "error-snackbar"
            });
          }
        },
        (error) => {
          this.snackbar.open("Signup failed. Please try again later.", "Close", {
            duration: 5000,
            panelClass: "error-snackbar"
          });
          console.error("Signup error:", error);
        }
      );
    }
  }
}
