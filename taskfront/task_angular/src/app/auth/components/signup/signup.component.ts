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

      const signupData = {
        name: this.signupForm.get("name")?.value,
        email: this.signupForm.get("email")?.value,
        password: password
      };

      console.log("Sending signup request:", signupData);

      this.authService.signup(signupData).subscribe(
        (res) => {
          console.log("Signup response:", res);
          if (res && res.id != null) {
            this.snackbar.open("Signup successful", "Close", { duration: 5000 });
            this.router.navigate(['/login']);
          } else {
            this.snackbar.open("Signup Failed. Try again!", "Close", {
              duration: 5000,
              panelClass: "error-snackbar"
            });
          }
        },
        (error) => {
          console.error("Signup error:", error);
          this.snackbar.open("An error occurred. Please try again.", "Close", {
            duration: 5000,
            panelClass: "error-snackbar"
          });
        }
      );
    } else {
      this.snackbar.open("Please fill all required fields correctly.", "Close", {
        duration: 5000,
        panelClass: "error-snackbar"
      });
    }
  }
}
