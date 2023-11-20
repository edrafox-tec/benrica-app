import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
// import { NgxMaskModule } from 'ngx-mask';
// import { SearchBarComponent } from '../Components/search-bar/search-bar.component';
// import { SpinnerComponent } from '../Components/spinner/spinner.component';
// import { UnpaidPaymentComponent } from '../Components/unpaid-payment/unpaid-payment.component';
// import { ForgotPasswordComponent } from './../Pages/forgot-password/forgot-password.component';



@NgModule({
  declarations: [
    // SpinnerComponent,
    // SearchBarComponent,
    // ForgotPasswordComponent,
    // UnpaidPaymentComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    // NgxMaskModule,
    ReactiveFormsModule,
    HttpClientModule,
  ],
  exports: [
    // SpinnerComponent,
    // NgxMaskModule,
    ReactiveFormsModule,
    HttpClientModule,
    // SearchBarComponent,
    // ForgotPasswordComponent,
    // UnpaidPaymentComponent
  ],
})
export class SharedModule { }
