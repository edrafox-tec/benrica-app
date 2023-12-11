import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { LoggedPageRoutingModule } from './logged-routing.module';

import { LoggedPage } from './logged.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    LoggedPageRoutingModule
  ],
  declarations: [LoggedPage]
})
export class LoggedPageModule {}
