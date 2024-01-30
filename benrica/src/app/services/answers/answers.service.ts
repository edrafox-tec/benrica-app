import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { StringHelp } from 'src/app/utils/string.help';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class AnswersService {


  constructor(
    private requestService: RequestService,
  ) { }


  public async getAnswer(): Promise<any[]> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_ANSWERS,
      );
  }

  public async getAnswerId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_ANSWER_ID, [
        { id: id },
      ]),);
  }

  public async deleteAnswer(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_ANSWER, [
        { id: id },
      ]),);
  }

  public async createAnswer(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_ANSWER, formData);
  }


  public async updateAnswer(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_ANSWER, [
        { id: id },
      ]), formData);
  }
}
