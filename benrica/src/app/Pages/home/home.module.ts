import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { HomePageRoutingModule } from './home-routing.module';

import { ModalServiceDetailsComponent } from 'src/app/Components/modal-service-details/modal-service-details.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { HomePage } from './home.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    HomePageRoutingModule,
    SharedModule
  ],
  declarations: [
    HomePage,
    ModalServiceDetailsComponent
  ]
})
export class HomePageModule { }
