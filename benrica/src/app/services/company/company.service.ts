import { Injectable } from '@angular/core';
import { ApiUrl } from 'src/app/models/apiUrl';
import { FormDataUtil } from 'src/app/utils/formData.util';
import { StringHelp } from 'src/app/utils/string.help';
import { RequestService } from '../request/request.service';

@Injectable({
  providedIn: 'root'
})
export class CompanyService {

  constructor(
    private requestService: RequestService,
  ) { }


  public async getCompany(): Promise<any[]> {
    return await this.requestService
      .setHeaderToken()
      .post(
        ApiUrl.GET_COMPANIES,
      );
  }

  public async getCompanyId(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_COMPANY_ID, [
        { id: id },
      ]),);
  }

  public async getCompanyName(name: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.GET_COMPANY_NAME, [
        { name: name },
      ]),);
  }

  public async deleteCompany(id: any) {
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.DELETE_COMPANY, [
        { id: id },
      ]),);
  }

  public async createCompany(data: any): Promise<any[]> {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(ApiUrl.ADD_COMPANY, formData);
  }


  public async updateCompany(data: any, id: any) {
    const formData = FormDataUtil.createFormData([data]);
    return await this.requestService
      .setHeaderToken()
      .post(StringHelp.replaceParametersWithValue(ApiUrl.UPDATE_COMPANY, [
        { id: id },
      ]),
        formData
      );
  }
}

