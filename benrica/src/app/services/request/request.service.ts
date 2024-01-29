import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { MethodHttpEnum } from '../../models/method-http';
import { ToastColor } from '../../models/toast';
import { LoggedService } from '../logged/logged.service';
import { ToastService } from '../toaster/toast.service';

@Injectable({
  providedIn: 'root',
})
export class RequestService {
  private headers!: HttpHeaders;

  constructor(
    private http: HttpClient,
    private router: Router,
    private LoggedService: LoggedService,
    private toastService: ToastService,
  ) {
    this.headers = new HttpHeaders();
  }

  public async post(urlRequest: string, body?: any, params?: {}): Promise<any> {
    try {
      const result = await this.request(MethodHttpEnum.POST, urlRequest, body, params);
      if (result?.status === 'O token expirou' || result?.status === 'Token Invalido'
        || result?.status === 'Token expirado') {
        this.presentToastWithOptions('Você será desconectado em breve!', 'success');
        setTimeout(() => {
          this.LoggedService.clear()
          this.router.navigate(['/login'])
          localStorage.removeItem('tokenCopy')
          localStorage.removeItem('token')
          localStorage.removeItem('loginType')
        }, 10000);

        setTimeout(() => {
          window.location.reload();
        }, 11000);
      }
      else if (result?.status === 'Autorização não encontrada') {
        throw new Error(result?.status);
      }
      return result;
    } catch (error: any) {
      if (error instanceof HttpErrorResponse && error.status === 200) {
        return error.error.text;
      } else {
        throw new Error(error);
      }
    }
  }


  public async get(urlRequest: string, body?: any, params?: {}): Promise<any> {
    return await this.request(MethodHttpEnum.GET, urlRequest, body, params);
  }

  private async request(
    method: MethodHttpEnum,
    urlRequest: string,
    body?: any,
    params?: {},
  ): Promise<any> {
    return await this.http
      .request(method, urlRequest, {
        headers: this.headers,
        body,
        params,
      })
      .toPromise();
  }

  public setHeaderToken(token?: string): this {
    this.headers = this.headers.set(
      'Authorization',
      'Bearer ' + (
        token ||
        this.LoggedService.getToken()
      )?.replace(/^"(.*)"$/, '$1'),
    );
    return this;
  }

  public setHeader(chave: string, valor: string): this {
    this.headers.set(chave, valor);
    return this;
  }

  public presentToastWithOptions(message: string, color: ToastColor): void {
    this.toastService
      .setMessage(message)
      .setIcon('information-circle')
      .setColor(color)
      .setDuration(10000)
      .showToast();
  }
}
