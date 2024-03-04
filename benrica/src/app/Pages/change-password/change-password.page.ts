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
  selector: 'app-change-password',
  templateUrl: './change-password.page.html',
  styleUrls: ['./change-password.page.scss'],
})
export class ChangePasswordPage implements OnInit {
  public showSpinner = false
  public user: userResponseInterface = this.loggedService.getUser()

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
    private toastService: ToastService,
    private usersService: UsersService,
    private loggedService: LoggedService,
    private alertController: AlertController,
  ) { }

  ngOnInit() {
  }

  ionViewWillEnter() {
    this.password.reset()
    this.confirmPassword.reset()
  }

  back() {
    this.confirmationClose()
  }

  async changePassword() {
    if (this.validateInput())
      try {
        this.showSpinner = true
        const data = {
          new_password: this.password.value,
        }
        const resp = await this.usersService.updatePassword(data, this.user.id)

        console.log(resp);
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

  validateInput() {
    const validate = this.password.valid && this.confirmPassword.valid
    this.password.markAsTouched();
    this.confirmPassword.markAsTouched();
    return validate
  }


  public presentToastWithOptions(message: string, color: ToastColor): void {
    this.toastService
      .setMessage(message)
      .setIcon('information-circle')
      .setColor(color)
      .setDuration(700)
      .showToast();
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
