import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { StringHelp } from 'src/app/utils/string.help';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class SchedulingService {


  constructor(
    private requestService: RequestService,
  ) { }


  public async getScheduling(): Promise<any[]> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_SCHEDULING,
      );
  }

  public async getSchedulingId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_SCHEDULING_ID, [
        { id: id },
      ]),);
  }

  public async deleteScheduling(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_SCHEDULING, [
        { id: id },
      ]),);
  }

  public async createScheduling(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_SCHEDULING, formData);
  }


  public async updateScheduling(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_SCHEDULING, [
        { id: id },
      ]), formData);
  }
}
