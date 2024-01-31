import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { CompaniesPageRoutingModule } from './companies-routing.module';

import { SharedModule } from 'src/app/shared/shared.module';
import { CompaniesPage } from './companies.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    CompaniesPageRoutingModule,
    SharedModule
  ],
  declarations: [CompaniesPage]
})
export class CompaniesPageModule { }
