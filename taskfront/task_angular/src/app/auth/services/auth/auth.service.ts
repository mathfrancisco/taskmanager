import { Injectable, Inject } from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpHeaders} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiUrl = 'http://localhost:8080/','http://meu-backend.elasticbeanstalk.com/';
  constructor(
    private http: HttpClient
  ) {}
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    }),
    withCredentials: true
  };

  signup(signupRequest: any): Observable<any> {
    return this.http.post(`${this.apiUrl}api/auth/signup`, signupRequest, this.httpOptions).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 409) {
          // Usuário já existe
          return throwError(() => new Error("User with this email already exists."));
        } else {
          return throwError(() => new Error("An unexpected error occurred."));
        }
      })
    );
  }

  login(loginRequest: any): Observable<any> {
    return this.http.post(`${this.apiUrl}api/auth/login`, loginRequest, this.httpOptions).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 409) {
          // Usuário já existe
          return throwError(() => new Error("User with this email already exists."));
        } else {
          return throwError(() => new Error("An unexpected error occurred."));
        }
      })
    );
  }
}
