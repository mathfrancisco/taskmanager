import { Component, OnInit } from '@angular/core';
import { StorageService } from "./auth/services/storage/storage.service";
import { Router, NavigationEnd } from "@angular/router";
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  isEmployeeLoggedIn: boolean = false;
  isAdminLoggedIn: boolean = false;

  constructor(private router: Router) {}

  ngOnInit() {
    this.updateLoginStatus();
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      this.updateLoginStatus();
    });
  }

  updateLoginStatus() {
    this.isEmployeeLoggedIn = StorageService.isEmployeeLoggedIn();
    this.isAdminLoggedIn = StorageService.isAdminLoggedIn();
  }

  logout() {
    StorageService.logout();
    this.updateLoginStatus();
    this.router.navigateByUrl("/login");
  }
}
