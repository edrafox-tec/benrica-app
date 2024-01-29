import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { loginResponseInterface } from 'src/app/models/interfacesResponse';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(
    private requestService: RequestService,
  ) { }

  public async login(data: { email: string | null, password: string | null }): Promise<loginResponseInterface> {
    const formDataLogin = FormDataUtil.createFormData([data]);
    return await this.requestService.post(
      ApiUrl.LOGIN,
      formDataLogin
    );
  }
}
