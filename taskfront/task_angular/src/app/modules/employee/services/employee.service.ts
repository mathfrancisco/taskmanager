import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {StorageService} from "../../../auth/services/storage/storage.service";
import {Observable} from "rxjs";

const BASIC_URL = "http://localhost:8080/";
@Injectable({
  providedIn: 'root'
})

export class EmployeeService {

  constructor(private http:HttpClient) {

}
  getEmployeeTasksById(): Observable<any> {
    return this.http.get(BASIC_URL + "api/employee/tasks", {
      headers: this.createAuthorizationHeader()
    })
  }

  updateStatus(id:number,status:string): Observable<any> {
    return this.http.get(BASIC_URL + `api/employee/task/${id}/${status}`, {
      headers: this.createAuthorizationHeader()
    })
  }

  getTaskById(id: number): Observable<any> {
    return this.http.get(BASIC_URL + "api/employee/task/" + id, {
      headers: this.createAuthorizationHeader()
    })
  }
  createComment(id: number, content: string): Observable<any> {
    const body = { content: content };
    return this.http.post(BASIC_URL + "api/employee/task/comment/" + id, body, {
      headers: this.createAuthorizationHeader()
    });
  }

  getCommentsByTask(id: number): Observable<any> {
    return this.http.get(BASIC_URL + "api/employee/comments/" + id, {
      headers: this.createAuthorizationHeader()
    });
  }

  private createAuthorizationHeader(): HttpHeaders {
    return new HttpHeaders().set('Authorization', 'Bearer ' + StorageService.getToken())
  }
}
