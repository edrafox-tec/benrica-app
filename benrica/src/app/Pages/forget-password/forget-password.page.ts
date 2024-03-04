import { Component, OnInit } from '@angular/core';
import { AbstractControl, AsyncValidatorFn, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AlertController } from '@ionic/angular';
import { userResponseInterface } from 'src/app/models/interfacesResponse';
import { ToastColor } from 'src/app/models/toast';
import { LoggedService } from 'src/app/services/logged/logged.service';
import { ToastService } from 'src/app/services/toaster/toast.service';
import { UsersService } from 'src/app/services/users/users.service';

@Component({
  selector: 'app-forget-password',
  templateUrl: './forget-password.page.html',
  styleUrls: ['./forget-password.page.scss'],
})
export class ForgetPasswordPage implements OnInit {
  public step = 1
  public showSpinner = false
  public user: userResponseInterface = this.loggedService.getUser()

  public code = new FormControl('', [
    Validators.required,
    Validators.minLength(6),
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
    private router: Router,
    private loggedService: LoggedService,
    private toastService: ToastService,
    private usersService: UsersService,
    private alertController: AlertController,
  ) { }

  ngOnInit() {
    this.user = this.loggedService.getUser()
  }

  ionViewWillEnter() {
    this.step = 1
    this.sendCodeToEmail()
    this.password.reset()
    this.confirmPassword.reset()
    this.code.reset()
  }

  back() {
    if (this.step == 1) {
      this.confirmationClose()
    } else {
      this.step--
    }
  }

  next() {
    if (this.step == 1 && this.validateInputCode()) {
      this.step++
    } else if (this.step == 2) {
      this.resetPassword()
    }
  }

  async sendCodeToEmail() {
    try {
      this.showSpinner = true
      const data = {
        email: this.loggedService.getUser().email,
      }
      const resp = await this.usersService.sendCodeToEmail(data)
      if (resp.message !== 'E-mail de redefinição de senha enviado com sucesso!') {
        throw new Error('Unexpected response message');
      }
      console.log(resp);
      this.showSpinner = false
    } catch (error) {
      this.presentToastWithOptions(
        'Erro ao enviar código.',
        'danger'
      );
      this.showSpinner = false
      this.router.navigate(['logged/settings'])
    }
  }

  async resetPassword() {
    if (this.validateInputReset())
      try {
        this.showSpinner = true
        const data = {
          email: this.loggedService.getUser().email,
          password: this.password.value,
          token: this.code.value,
        }
        const resp = await this.usersService.resetPassword(data)
        console.log(resp);
        if (resp.message === 'Esse token não é válido.') {
          this.step = 1
          this.code.setValue('')
          this.code.markAsTouched();
          this.presentToastWithOptions(
            'Esse token não é válido.',
            'danger'
          );
          throw new Error('Unexpected response message');
        }
        this.presentToastWithOptions(
          'Senha alterada com sucesso.',
          'success'
        );
        this.router.navigate(['/logged/settings'])
        this.showSpinner = false
      } catch (error) {
        this.presentToastWithOptions(
          'Erro ao alterar senha.',
          'danger'
        );
        this.showSpinner = false
      }
  }

  validateInputReset() {
    const validate = this.password.valid && this.confirmPassword.valid && this.code.valid
    this.password.markAsTouched();
    this.confirmPassword.markAsTouched();
    this.code.markAsTouched();
    return validate
  }

  validateInputCode() {
    const validate = this.code.valid
    this.code.markAsTouched();
    return validate
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

  async confirmationClose() {
    const alert = await this.alertController.create({
      header: 'Sair',
      message: 'Tem certeza de que deseja sair?',
      buttons: [
        {
          text: 'Sim',
          handler: () => {
            this.router.navigate(['logged/settings'])
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

  public presentToastWithOptions(message: string, color: ToastColor): void {
    this.toastService
      .setMessage(message)
      .setIcon('information-circle')
      .setColor(color)
      .setDuration(700)
      .showToast();
  }

}
