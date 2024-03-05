import { LoggedService } from 'src/app/services/logged/logged.service';
/* eslint-disable @angular-eslint/no-empty-lifecycle-method */
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ApiUrl } from 'src/app/models/apiUrl';
import { companyResponseInterface } from 'src/app/models/interfacesResponse';
import { CompanyService } from 'src/app/services/company/company.service';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';

@Component({
  selector: 'app-splash',
  templateUrl: './splash.page.html',
  styleUrls: ['./splash.page.scss'],
})
export class SplashPage implements OnInit {
  public showSpinner = true
  public company: companyResponseInterface = {
    id: 0,
    exclusive: 0,
    business_name: '',
    email: '',
    phone: '',
    cnpj: '',
    password: '',
    reset_pass: null,
    logo_img: null,
    facebook: null,
    instagram: null,
    tiktok: null,
    business_information: null,
    deleted_at: null,
    created_at: '',
    updated_at: null
  }
  public urlImage = ApiUrl.URL_IMAGE + 'businesses/'
  public storeName: string = ''


  constructor(
    private router: Router,
    private localStorageService: LocalStorageService,
    private companyService: CompanyService,
    private loggedService: LoggedService,
    private route: ActivatedRoute
  ) { }

  ngOnInit() {
  }

  ionViewDidEnter() {
    this.storeName = this.route.snapshot.params['storeName'];
    if (this.storeName === undefined) {
      this.router.navigate(['companies'])
      return
    }
    this.listingCompany()
  }

  async listingCompany() {
    try {
      this.showSpinner = true
      this.company = await this.companyService.getCompanyName(this.storeName.toLowerCase().replace(/\s/g, '_'));
      this.loggedService.setCompany(this.company)
      setTimeout(() => {
        this.verifyNextPage()
      }, 3000);
      this.showSpinner = false
    } catch (error) {
      this.router.navigate(['/splash/' + this.storeName])
      console.error(error);
      return Promise.reject(error);
    }
  }


  verifyNextPage() {
    this.router.navigate(['/login/' + this.storeName])
  }

}
