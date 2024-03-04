import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { serviceResponseInterface } from 'src/app/models/interfacesResponse';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { StringHelp } from 'src/app/utils/string.help';
import { LoggedService } from '../logged/logged.service';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class ServiceService {

  constructor(
    private requestService: RequestService,
    private loggedService: LoggedService,
  ) { }


  public async getService(): Promise<serviceResponseInterface> {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_SERVICES, [
        { id: this.loggedService.getUser().id_businesses },
      ]),);
  }

  public async getServiceId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_SERVICE_ID, [
        { id: id },
      ]),);
  }

  public async deleteService(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_SERVICE, [
        { id: id },
      ]),);
  }

  public async createService(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_SERVICE, formData);
  }


  public async updateService(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_SERVICE, [
        { id: id },
      ]), formData);
  }
}
