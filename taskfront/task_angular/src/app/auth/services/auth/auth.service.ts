import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

const BASE_URL = 'http://localhost:8080/';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(private http: HttpClient) {}

  signup(signupRequest: any): Observable<any> {
    return this.http.post(BASE_URL + 'api/auth/signup', signupRequest).pipe(
      catchError((error: HttpErrorResponse) => {
        return throwError(() => error); // Pass the whole error object to handle it better in the component
      })
    );
  }

  login(loginRequest: any): Observable<any> {
    return this.http.post(BASE_URL + 'api/auth/login', loginRequest);
  }
}
