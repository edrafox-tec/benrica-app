import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { companyResponseInterface } from 'src/app/models/interfacesResponse';
import { CompanyService } from 'src/app/services/company/company.service';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';

@Component({
  selector: 'app-companies',
  templateUrl: './companies.page.html',
  styleUrls: ['./companies.page.scss'],
})
export class CompaniesPage implements OnInit {
  public showSpinner = false
  public companies: companyResponseInterface[] = []
  public oldCompanies: companyResponseInterface[] = []
  public inputSearch = ''


  constructor(
    private companyService: CompanyService,
    private router: Router,
    private localStorageService: LocalStorageService,
  ) { }

  ngOnInit() {
    this.listingCompany()
  }

  async listingCompany() {
    try {
      this.showSpinner = true
      this.companies = await this.companyService.getCompany();
      this.oldCompanies = this.companies
      this.showSpinner = false
    } catch (error) {
      this.showSpinner = false
      console.error(error);
      return Promise.reject(error);
    }
  }

  selectCompany(company: companyResponseInterface) {
    this.localStorageService.setEncrypt('bernrica-store', company)
    localStorage.setItem('storeName', company.business_name.toLowerCase().replace(/\s/g, '_'))
    this.router.navigate(['/splash/' + company.business_name.toLowerCase().replace(/\s/g, '_')])
  }

  clearSearch() {
    this.companies = this.oldCompanies;
    this.inputSearch = ''
  }

  controlInput(event: any) {
    if (event.target.value == '') {
      this.clearSearch()
    }
  }

  searchInput(event: any) {
    const text = event.target.value;
    if (text === '') {
      this.companies = this.oldCompanies;
    } else {
      const formattedText = text.toLowerCase();
      const filtered = this.oldCompanies.filter((element: any) => {
        const formattedName = Array.isArray(element.business_name) ?
          element.business_name.some((item: any) => item.toLowerCase().includes(formattedText)) :
          element.business_name?.toLowerCase().includes(formattedText);
        return formattedName
      });
      const uniqueFiltered = filtered.filter((value: any, index: number, self: any) =>
        self.findIndex((item: any) => item.id === value.id) === index
      );
      this.companies = uniqueFiltered;
    }
  }

}
