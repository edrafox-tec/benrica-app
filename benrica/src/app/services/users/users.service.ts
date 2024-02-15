import { Injectable } from '@angular/core';
import { createFullUserInterface } from 'src/app/models/interfacesRequest';
import { userResponseInterface } from 'src/app/models/interfacesResponse';
import { ApiUrl } from './../../models/apiUrl';
import { FormDataUtil } from './../../utils/formData.util';
import { StringHelp } from './../../utils/string.help';
import { RequestService } from './../request/request.service';


@Injectable({
  providedIn: 'root'
})
export class UsersService {

  constructor(
    private requestService: RequestService,
  ) { }


  public async getUser(): Promise<userResponseInterface> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_USERS,
      );
  }


  public async getUserId(id: string | number) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_USER_ID, [
        { id: id },
      ]),);
  }

  public async deleteUser(id: string | number) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_USER, [
        { id: id },
      ]),);
  }

  public async createUser(data: createFullUserInterface): Promise<userResponseInterface> {
    const formData = FormDataUtil.createFormDataAnswers([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_USER, formData);
  }

  public async saveUserAnswers(data: any): Promise<any> {
    const formData = FormDataUtil.createFormDataAnswers([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.SAVE_USER_ANSWERS, formData);
  }


  public async updateUser(data: any, id: string | number) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_USER, [
        { id: id },
      ]), formData);
  }

  public async updatePassword(data: any, id: string | number) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_PASSWORD, [
        { id: id },
      ]), formData);
  }
}
