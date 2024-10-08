import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders, HttpParams} from "@angular/common/http";
import { Observable } from "rxjs";
import { StorageService } from "../../../auth/services/storage/storage.service";

const BASIC_URL = "http://localhost:8080/";

@Injectable({
  providedIn: 'root'
})
export class AdminService {

  constructor(private http: HttpClient) { }

  getUsers(): Observable<any> {
    return this.http.get(BASIC_URL + "api/admin/users", {
      headers: this.createAuthorizationHeader()
    })
  }

  postTask(taskDto: any): Observable<any> {
    return this.http.post(BASIC_URL + "api/admin/task", taskDto, {
      headers: this.createAuthorizationHeader()
    })
  }

  getAllTasks(): Observable<any> {
    return this.http.get(BASIC_URL + "api/admin/tasks", {
      headers: this.createAuthorizationHeader()
    })
  }

  deleteTask(id: number): Observable<any> {
    return this.http.delete(BASIC_URL + "api/admin/task/" + id, {
      headers: this.createAuthorizationHeader()
    })
  }
  getTaskById(id: number): Observable<any> {
    return this.http.get(BASIC_URL + "api/admin/task/" + id, {
      headers: this.createAuthorizationHeader()
    })
  }
  updateTask(id: number, taskDto: any): Observable<any> {
    return this.http.put(BASIC_URL + `api/admin/task/${id}`, taskDto, {
      headers: this.createAuthorizationHeader()
    })
  }

  searchTask(title: string): Observable<any> {
    let params = new HttpParams();
    if (title) {
      params = params.set('title', title);
    }
    return this.http.get(BASIC_URL + `api/admin/tasks/search/${title}`, {
      headers: this.createAuthorizationHeader(),
      params: params
    });
  }

  private createAuthorizationHeader(): HttpHeaders {
    return new HttpHeaders().set('Authorization', 'Bearer ' + StorageService.getToken())
  }
}
