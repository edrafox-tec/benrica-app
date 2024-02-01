import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { StringHelp } from 'src/app/utils/string.help';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class QuestionsService {

  constructor(
    private requestService: RequestService,
  ) { }


  public async getQuestion(): Promise<any[]> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_QUESTIONS,
      );
  }

  public async getQuestionId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_QUESTION_ID, [
        { id: id },
      ]),);
  }

  public async getQuestionsAndAnswers(data: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.GET_QUESTIONS_AND_ANSWERS, formData);
  }

  public async deleteQuestion(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_QUESTION, [
        { id: id },
      ]),);
  }

  public async createQuestion(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_QUESTION, formData);
  }


  public async updateQuestion(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_QUESTION, [
        { id: id },
      ]), formData);
  }
}
