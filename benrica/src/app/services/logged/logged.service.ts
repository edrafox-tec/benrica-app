import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable, Subject } from 'rxjs';
import { LocalStorageService } from '../local-storage/local-storage.service';
import { KeyLocalStorage } from './../../models/key-localStorage';
import { SecretUtil } from './../../utils/secret-util';
import { AuthService } from './../auth-guard/auth-service';

@Injectable({
  providedIn: 'root',
})
export class LoggedService {
  private tokenPush = ''
  private userSubject: Subject<any> = new Subject<any>();

  constructor(
    private localStorageService: LocalStorageService,
    private router: Router,
    private authService: AuthService,
  ) { }

  public clear(): Function {
    this.localStorageService.remove(KeyLocalStorage.USER);
    this.localStorageService.remove(KeyLocalStorage.USER_TOKEN);
    this.localStorageService.remove(KeyLocalStorage.USER_PERMISSION_ADM);
    this.localStorageService.remove(KeyLocalStorage.LOGIN);
    return this.clearForce;
  }

  public clearForce(): boolean {
    this.localStorageService.remove(KeyLocalStorage.USER);
    this.localStorageService.remove(KeyLocalStorage.USER_TOKEN);
    this.localStorageService.remove(KeyLocalStorage.USER_PERMISSION_ADM);
    this.localStorageService.remove(KeyLocalStorage.LOGIN);
    return true
  }

  public getUser() {
    let data: any = {}
    if (this.localStorageService.get(KeyLocalStorage.USER)) {
      data = JSON.parse(
        SecretUtil.decrypt(this.localStorageService.get(KeyLocalStorage.USER) || '{}')
      );
    }
    return data
  }

  public setUser(user: any): boolean {
    const result = this.localStorageService.set(
      KeyLocalStorage.USER,
      SecretUtil.encrypt(JSON.stringify(user))
    );

    if (result) {
      this.userSubject.next(user);
    }

    return result;
  }
  public getLogin() {
    let data: any = {}
    if (this.localStorageService.get(KeyLocalStorage.LOGIN)) {
      data = JSON.parse(
        SecretUtil.decrypt(this.localStorageService.get(KeyLocalStorage.LOGIN) || '{}')
      );
    }
    return data
  }

  public setLogin(login: { email: string, password: string }) {
    this.localStorageService.set(KeyLocalStorage.LOGIN, SecretUtil.encrypt(JSON.stringify(login)));
  }

  public getUserObservable(): Observable<any> {
    return this.userSubject.asObservable();
  }

  public setToken(token: any) {
    return this.localStorageService.set(KeyLocalStorage.USER_TOKEN, (token.access_token.replace(/^"|"$/g, '')));
  }

  public getToken(): string {
    return this.localStorageService.get(KeyLocalStorage.USER_TOKEN) || '{}';
  }

  public setPermissionAdm(permission: any) {
    return this.localStorageService.set(KeyLocalStorage.USER_PERMISSION_ADM, (permission));
  }

  public getPermissionAdm(): boolean {
    return this.stringToBoolean(this.localStorageService.get(KeyLocalStorage.USER_PERMISSION_ADM)) || false;
  }

  public setTokenPush(token: any) {
    this.localStorageService.set(KeyLocalStorage.USER_TOKEN_PUSH, token);
  }

  public getTokenPush(): string {
    return this.localStorageService.get(KeyLocalStorage.USER_TOKEN_PUSH) || ''
  }

  public exit() {
    setTimeout(() => {
      this.clear();
      this.router.navigateByUrl('/login', { replaceUrl: true });
      localStorage.removeItem('tokenCopy');
      localStorage.removeItem('token');
      localStorage.removeItem('loginType');
      this.authService.logout()
    }, 1000);

    setTimeout(() => {
      window.location.reload();
    }, 1100);
  }

  stringToBoolean(str: string): boolean {
    return str.toLowerCase() === "true";
  }
}
