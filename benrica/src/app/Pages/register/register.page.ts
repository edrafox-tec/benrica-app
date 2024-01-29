import { Component, OnInit } from '@angular/core';
import { AbstractControl, AsyncValidatorFn, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AlertController, Platform } from '@ionic/angular';
import { createUserInterface } from 'src/app/models/interfacesRequest';
import { companyResponseInterface } from 'src/app/models/interfacesResponse';
import { CompanyService } from 'src/app/services/company/company.service';
import { UsersService } from './../../services/users/users.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.page.html',
  styleUrls: ['./register.page.scss'],
})
export class RegisterPage implements OnInit {
  public progress = 0
  public steps = 2
  public step = 1
  public companies: companyResponseInterface[] = []
  public showSpinner = false

  public responseModal: { response: boolean, textTrue: string, textFalse: string } = {
    response: false,
    textTrue: 'Cadastro realizado com sucesso',
    textFalse: 'Ops! Ocorreu um erro Tente novamente!'
  }

  public name = new FormControl('', [
    Validators.required,
    Validators.minLength(3),
    Validators.pattern(/^[a-zA-ZÀ-ÿ\s']+$/)
  ]);

  public email = new FormControl('', [
    Validators.required,
    Validators.minLength(3),
    Validators.email
  ]);

  public phone = new FormControl('', [
    Validators.required,
    Validators.minLength(11),
    Validators.maxLength(11),
    Validators.pattern(/^[0-9]+$/)
  ]);

  public company = new FormControl('', [
    Validators.required,
  ]);

  public blood = new FormControl('', [
    Validators.required,
  ]);

  public password = new FormControl('', [
    Validators.required,
    Validators.minLength(6),
  ]);

  public confirmPassword = new FormControl('', [
    Validators.required,
    Validators.minLength(6),
  ],
    [this.validateSamePassword()]);

  constructor(
    private platform: Platform,
    private alertController: AlertController,
    private router: Router,
    private usersService: UsersService,
    private companyService: CompanyService,
  ) { }

  ngOnInit() {
    this.progress = this.step / this.steps
    this.platform.backButton.subscribeWithPriority(10, () => {
      this.backStep()
    });
    this.listingCompany()
  }

  backStep() {
    switch (this.step) {
      case 1:
        this.confirmationClose()
        break
      case 2:
        this.step--
        this.progress = this.step / this.steps
        break
    }
  }

  nextStep() {
    switch (this.step) {
      case 1:
        if (this.validateUserField()) {
          this.step++
          this.progress = this.step / this.steps
          console.log('validateUserField');
        }
        break
      case 2:
        if (this.validateTrainingField()) {
          //create user
          // this.router.navigate(['/login'])
          this.createUser()
          this.step++
        }
        break
    }
  }

  async createUser(): Promise<any> {
    try {
      const data: createUserInterface = {
        user_name: this.name.value!,
        email: this.email.value!,
        phone_number: this.phone.value!,
        id_businesses: this.company.value!,
        password: this.password.value!,
        access_level: 0,
      };
      console.log(data);
      const resp: any = await this.usersService.createUser(data);
      console.log(resp);
      // if (resp.success === true && resp.text == "OK") {
      //   this.customer_id = resp.data.id;
      // } else {
      //   this.savePaymentData()
      //   throw new Error("Erro na criação do cliente");
      // }
    } catch (error) {
      console.error(error);
      return Promise.reject(error);
    }
  }

  async listingCompany() {
    try {
      this.showSpinner = true
      this.companies = await this.companyService.getCompany();
      this.showSpinner = false
    } catch (error) {
      this.showSpinner = false
      console.error(error);
      return Promise.reject(error);
    }
  }

  async confirmationClose() {
    const alert = await this.alertController.create({
      header: 'Sair',
      message: 'Tem certeza de que deseja sair?',
      buttons: [
        {
          text: 'Sim',
          handler: () => {
            this.router.navigate(['/login'])
          }
        },
        {
          text: 'Não',
          role: 'cancel'
        }
      ]
    });
    await alert.present();
  }

  validateUserField() {
    const validate = this.name.valid && this.email.valid && this.phone.valid
      && this.company.valid && this.password.valid && this.confirmPassword.valid

    this.name.markAsTouched();
    this.email.markAsTouched();
    this.phone.markAsTouched();
    this.company.markAsTouched();
    this.password.markAsTouched();
    this.confirmPassword.markAsTouched();
    return validate
  }

  validateTrainingField() {
    // const validate = this.birthday.valid && this.trainingLevel.valid

    // this.birthday.markAsTouched();
    // this.trainingLevel.markAsTouched();

    return true
  }

  toggleActionButton() {
    if (this.responseModal.response) {
      this.router.navigate(['/login'])
    } else {
      this.step = 1
      this.progress = this.step / this.steps
    }
  }

  validateSamePassword(): AsyncValidatorFn {
    return (control: AbstractControl) => {
      if (this.confirmPassword.value!.length > 0) {
        const verify = this.password.value === this.confirmPassword.value;

        return new Promise((resolve) => {
          if (verify) {
            this.confirmPassword.setErrors({ differentPassword: false });
            resolve(null);
          } else {
            this.confirmPassword.setErrors({ differentPassword: true });
            resolve({ differentPassword: true });
          }
        });
      } else {
        this.confirmPassword.setErrors({ differentPassword: false });
        return Promise.resolve(null);
      }
    };
  }

  validateInputsErros() {
    if (this.confirmPassword.errors && this.confirmPassword.errors['differentPassword'] !== true) {
      return false;
    } else if (this.confirmPassword.errors && this.confirmPassword.errors['differentPassword'] === true) {
      return true;
    } else {
      return false;
    }
  }
}
