import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import {AuthService} from "../../services/auth/auth.service";
import {MatSnackBar} from "@angular/material/snack-bar";
import {Router} from "@angular/router";
import {StorageService} from "../../services/storage/storage.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  loginForm!: FormGroup;
  hidePassword = true;

  constructor(private fb: FormBuilder,
              private authService: AuthService,
              private snackbar: MatSnackBar,
              private router: Router) {}

  ngOnInit() {
    this.initForm();
  }

  initForm() {
    this.loginForm = this.fb.group({
      email: [null, [Validators.required, Validators.email]],
      password: [null, [Validators.required]]
    });
  }

  togglePasswordVisibility() {
    this.hidePassword = !this.hidePassword;
  }

  onSubmit() {
    if (this.loginForm.valid) {
      console.log(this.loginForm.value);
      this.authService.login(this.loginForm.value).subscribe(
        (res) => {
          if (res.jwt) {  // Alterar verificação para o campo correto
            const user ={
              id: res.userId,
              role: res.userRole,
            }
            StorageService.saveUser(user);
            StorageService.saveToken(res.jwt);
            if(StorageService.isAdminLoggedIn())
              this.router.navigateByUrl("/admin/dashboard");
            else if (StorageService.isEmployeeLoggedIn())
              this.router.navigateByUrl("/employee/dashboard")
            this.snackbar.open(`Login successful. Welcome!`, "Close", { duration: 5000 });
          } else {
            this.snackbar.open("Login failed. Unexpected response format.", "Close", {
              duration: 5000,
              panelClass: "error-snackbar"
            });
          }
        }
      );
    }
  }
}
