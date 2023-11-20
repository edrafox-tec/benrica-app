// auth.service.ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private isAuthenticated: boolean = true;

  constructor() { }
  isAuthenticatedUser(): boolean {
    return this.isAuthenticated;
  }
  login(): void {
    this.isAuthenticated = true;
  }
  logout(): void {
    this.isAuthenticated = false;
  }
}
