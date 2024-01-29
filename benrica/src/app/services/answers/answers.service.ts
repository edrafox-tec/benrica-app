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


  public async getCollaborator(): Promise<any[]> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_COLLABORATORS,
      );
  }

  public async getCollaboratorId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_COLLABORATOR_ID, [
        { id: id },
      ]),);
  }

  public async deleteCollaborator(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_COLLABORATOR, [
        { id: id },
      ]),);
  }

  public async createCollaborator(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_COLLABORATOR, formData);
  }


  public async updateCollaborator(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_COLLABORATOR, [
        { id: id },
      ]), formData);
  }
}
