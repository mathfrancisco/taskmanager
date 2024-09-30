import { Component } from '@angular/core';
import { FormBuilder,FormGroup, Validators } from "@angular/forms";
@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent {
  signupForm!: FormGroup;
  hidePassword=true;

  constructor(private fb: FormBuilder){
    this.signupForm = this.fb.group({
      name: [null,[Validators.required]],
      email: [null,[Validators.required,Validators.email]],
      password: [null,[Validators.required]],
      confirmPassword: [null,[Validators.required]],
    })
  }
  togglePasswordVisibility(){
   this.hidePassword=!this.hidePassword;
  }

  onSubmit(){
    console.log(this.signupForm.value);
  }
}
