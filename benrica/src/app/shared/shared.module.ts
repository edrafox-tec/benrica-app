import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { NgxMaskModule } from 'ngx-mask';
import { SpinnerComponent } from '../Components/spinner/spinner.component';

@NgModule({
  declarations: [
    SpinnerComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    NgxMaskModule,
    ReactiveFormsModule,
    HttpClientModule,
  ],
  exports: [
    SpinnerComponent,
    NgxMaskModule,
    ReactiveFormsModule,
    HttpClientModule,
    NgxMaskModule
  ],
})
export class SharedModule { }
