import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { ForgetPasswordPageRoutingModule } from './forget-password-routing.module';

import { SharedModule } from 'src/app/shared/shared.module';
import { ForgetPasswordPage } from './forget-password.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ForgetPasswordPageRoutingModule,
    SharedModule
  ],
  declarations: [ForgetPasswordPage]
})
export class ForgetPasswordPageModule { }
