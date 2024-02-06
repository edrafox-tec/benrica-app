import { Component, OnInit } from '@angular/core';
import { AbstractControl, AsyncValidatorFn, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { AlertController, Platform } from '@ionic/angular';
import { createFullUserInterface } from 'src/app/models/interfacesRequest';
import { companyResponseInterface } from 'src/app/models/interfacesResponse';
import { ToastColor } from 'src/app/models/toast';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';
import { ToastService } from 'src/app/services/toaster/toast.service';
import { QuestionsService } from './../../services/questions/questions.service';
import { UsersService } from './../../services/users/users.service';
// import { Filesystem, Directory } from '@capacitor/filesystem';
// import { Preferences } from '@capacitor/preferences';

@Component({
  selector: 'app-register',
  templateUrl: './register.page.html',
  styleUrls: ['./register.page.scss'],
})
export class RegisterPage implements OnInit {
  public progress = 0
  public steps = 2
  public step = 1
  public questions: any[] = []
  public showSpinner = false
  public form: any = new FormGroup({})
  public store: companyResponseInterface = {
    id: '',
    business_name: '',
    email: '',
    phone: '',
    cnpj: '',
    password: '',
    reset_pass: null,
    logo_img: null,
    facebook: null,
    instagram: null,
    business_information: null,
    deleted_at: null,
    created_at: '',
    updated_at: null
  }

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
    private questionsService: QuestionsService,
    private localStorageService: LocalStorageService,
    private toastService: ToastService,

  ) { }

  ngOnInit() {
    this.store = this.localStorageService.getEncrypt('bernrica-store')
    this.progress = this.step / this.steps
    this.platform.backButton.subscribeWithPriority(10, () => {
      this.backStep()
    });
    this.listingQuestions()
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
    // this.saveAnswersUser(4)
    switch (this.step) {
      case 1:
        if (this.validateFirstStepField()) {
          this.step++
          this.progress = this.step / this.steps
        }
        break
      case 2:
        if (this.validateSecondStepField()) {
          this.createUser()
        }
        break
    }
  }

  async createUser(): Promise<any> {
    this.showSpinner = true
    try {
      const checkbox = (document.querySelectorAll('ion-checkbox'));
      let answers: { question_id: number; answer: string | number | number[]; type: string }[] = [];
      for (const key in this.form.value) {
        if (this.form.value.hasOwnProperty(key)) {
          const element = this.form.value[key];
          answers.push(
            {
              question_id: parseInt(key),
              answer: element,
              type: this.questions.find(element => element.id == key)?.question_type
            }
          )
        }
      }
      checkbox.forEach(checkbox => {
        answers.forEach((answer) => {
          if (checkbox.checked && parseInt(checkbox.id) == answer.question_id) {
            Array.isArray(answer.answer) ? null : answer.answer = []
            answer.answer.push(parseInt(checkbox.name))
          }
        });
      });
      const data: createFullUserInterface = {
        user_name: this.name.value!,
        email: this.email.value!,
        phone_number: this.phone.value!,
        id_businesses: this.store.id,
        password: this.password.value!,
        access_level: 0,
        all_answers: answers
      };
      console.log(data);
      const resp: any = await this.usersService.createUser(data);
      console.log(resp);
      this.showSpinner = false
      this.presentToastWithOptions(
        'Usuário criado com sucesso.',
        'success'
      );
      setTimeout(() => {
        this.router.navigate(['/login'])
      }, 2000);
    } catch (error) {
      console.error(error);
      this.presentToastWithOptions(
        'Oops, houve um erro ao criar usuário',
        'danger')
      this.showSpinner = false
      return Promise.reject(error);
    }
  }

  async saveAnswersUser(id: string | number) {
    try {
      const checkbox = (document.querySelectorAll('ion-checkbox'));
      let answers: { question_id: number; answer: any; type: string }[] = [];
      for (const key in this.form.value) {
        if (this.form.value.hasOwnProperty(key)) {
          const element = this.form.value[key];
          answers.push(
            {
              question_id: parseInt(key),
              answer: element,
              type: this.questions.find(element => element.id == key)?.question_type
            }
          )
        }
      }
      checkbox.forEach(checkbox => {
        answers.forEach((answer) => {
          if (checkbox.checked && parseInt(checkbox.id) == answer.question_id) {
            Array.isArray(answer.answer) ? null : answer.answer = []
            answer.answer.push(parseInt(checkbox.name))
          }
        });
      });
      const data = {
        id_user: id,
        all_answers: answers
      };
      console.log(data);
      const resp: any = await this.usersService.saveUserAnswers(data);
      console.log(resp);
      this.showSpinner = false

      //Fazer tela de sucesso ou falha
      this.presentToastWithOptions(
        'Usuário criado com sucesso.',
        'success'
      );

      this.router.navigate(['/login'])
    } catch (error) {
      this.presentToastWithOptions(
        'Oops, houve um erro ao criar usuário',
        'danger'
      );
      console.error(error);
      this.showSpinner = false
      return Promise.reject(error);
    }
  }

  async listingQuestions() {
    try {
      this.showSpinner = true;
      const data = {
        id_businesses: this.store.id
        // id_businesses: 1 //Retirar depois
      };
      const resp = await this.questionsService.getQuestionsAndAnswers(data);
      this.questions = resp.questions;
      this.questions.sort((a, b) => a.position - b.position);
      this.form = new FormGroup({});

      this.questions.forEach((x: any) => {
        if (x.answerType === 'draw' || x.required !== 1) {
          this.form.addControl(x.id, new FormControl(x.value));
        } else {
          if (x.answerType === 'checkbox' || x.answerType === 'radio') {
            x.answers.forEach((answer: any) => {
              answer.checked = false;
            });
          }
          this.form.addControl(x.id, new FormControl(x.value, Validators.required));
        }
      });
      Object.keys(this.form.controls).forEach((controlName) => {
        const control = this.form.get(controlName);
        if (control) {
          control.setValidators([Validators.required]);
          control.updateValueAndValidity();
        }
      });

      this.showSpinner = false;
    } catch (error) {
      this.showSpinner = false;
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

  validateFirstStepField() {
    const validate = this.name.valid && this.email.valid && this.phone.valid
      && this.password.valid && this.confirmPassword.valid
    this.name.markAsTouched();
    this.email.markAsTouched();
    this.phone.markAsTouched();
    this.password.markAsTouched();
    this.confirmPassword.markAsTouched();
    return validate
  }

  validateSecondStepField() {
    for (const controlName in this.form.controls) {
      if (this.form.controls.hasOwnProperty(controlName)) {
        const control = this.form.controls[controlName];
        control.markAsTouched();
      }
    }
    console.log(this.form);
    return this.form.status === "VALID" ? true : false;
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

  deleteImage(id: any,) {
    const change = {
      [id]: null
    }
    this.form.patchValue(change)
  }

  async takePicture(id: string | number) {
    this.showSpinner = true
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Prompt,
      saveToGallery: false
    });
    console.log(image.dataUrl);
    const change = {
      [id]: image.dataUrl
    }
    this.form.patchValue(change)
    this.showSpinner = false
  };

  public presentToastWithOptions(message: string, color: ToastColor): void {
    this.toastService
      .setMessage(message)
      .setIcon('information-circle')
      .setColor(color)
      .setDuration(700)
      .showToast();
  }
}
