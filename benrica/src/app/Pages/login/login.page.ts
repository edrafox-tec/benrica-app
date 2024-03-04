import { Component, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { SecureStorage } from '@ionic-native/secure-storage/ngx';
import { Platform } from '@ionic/angular';
import { NativeBiometric } from "capacitor-native-biometric";
import { ApiUrl } from 'src/app/models/apiUrl';
import { companyResponseInterface, loginResponseInterface } from 'src/app/models/interfacesResponse';
import { ToastColor } from 'src/app/models/toast';
import { AuthService } from 'src/app/services/auth-guard/auth-service';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';
import { LoggedService } from 'src/app/services/logged/logged.service';
import { LoginService } from 'src/app/services/login/login.service';
import { ToastService } from 'src/app/services/toaster/toast.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage implements OnInit {
  public showSpinner = false
  public company: companyResponseInterface = this.loggedService.getCompany()
  public urlImage = ApiUrl.URL_IMAGE + 'businesses/'
  public storeName = ''

  public email = new FormControl('', [
    Validators.required,
  ]);

  public password = new FormControl('', [
    Validators.required,
    Validators.minLength(6),
    Validators.maxLength(6),
  ]);
  constructor(
    private router: Router,
    private toastService: ToastService,
    private secureStorage: SecureStorage,
    private loginService: LoginService,
    private loggedService: LoggedService,
    private authService: AuthService,
    private platform: Platform,
    private localStorageService: LocalStorageService,
    private route: ActivatedRoute
  ) { }

  async ngOnInit() {
    if (this.localStorageService.get('fingerPrint') == 'true' ? true : false) {
      await this.restoreDataLogin()
    }
  }

  ionViewDidEnter() {
    this.storeName = this.route.snapshot.params['storeName'];
    console.log(this.storeName);
    if (this.route.snapshot.params['storeName'] === undefined) {
      this.router.navigate(['companies'])
    }
    if (localStorage.getItem('gustavo')) {
      this.email.setValue("gustavo@edrafox.com")
      this.password.setValue("123456")
    }
  }

  register() {
    this.router.navigate(['/register'])
  }
  private home() {
    this.router.navigate(['/logged/home'])
  }

  async login() {
    this.loggedService.clear();
    this.loggedService.setUser({});

    try {
      this.showSpinner = true;
      if (this.validateInputs()) {
        const login: loginResponseInterface = await this.loginService.login({
          email: this.email.value,
          password: this.password.value,
        });
        this.authService.login();
        this.loggedService.setUser(login.user);
        this.loggedService.setToken(login);
        this.loggedService.setLogin(
          {
            email: this.email.value!,
            password: this.password.value!,
          }
        );
        console.log(this.loggedService.getToken());

        if ((this.platform.platforms().includes('cordova') || this.platform.platforms().includes('android'))
          && this.localStorageService.get('fingerPrint') == 'true' ? true : false) {
          await this.saveFingerprintAndLogin()
        }
        this.home()
      }
    } catch (error) {
      this.presentToastWithOptions(
        'Oops, usuário e/ou senha inválidos.',
        'danger'
      );
      this.router.navigate(['/login'])
    } finally {
      this.showSpinner = false;
    }
  }

  async fastLoginFingerprint() {
    const result = await NativeBiometric.isAvailable();
    if (!result.isAvailable) return;
    const verified = await NativeBiometric.verifyIdentity({
      reason: "Login",
      title: "Entrar",
      subtitle: "Por favor, entre para ter acesso",
      description: "facilitador está utilizando autenticação biométrica",
    })
      .then(() => {
        this.setDataLogin()
        this.home()
      })
      .catch((erro) => {
        console.log(erro);
        this.presentToastWithOptions('Houve um erro, tente novamente.', 'danger')
      });
  }

  async saveFingerprintAndLogin() {
    const result = await NativeBiometric.isAvailable();
    if (!result.isAvailable) return;
    const verified = await NativeBiometric.verifyIdentity({
      reason: "Login",
      title: "Entrar",
      subtitle: "Por favor, entre para ter acesso",
      description: "facilitador está utilizando autenticação biométrica",
    })
      .then(() => {
        this.setDataLogin()
      })
  }

  async restoreDataLogin() {
    const credentials = await NativeBiometric.getCredentials({
      server: "www.example.com",
    });
    console.log(credentials);
    if (credentials) {
      this.email.setValue(credentials.username)
      this.password.setValue(credentials.password)
      this.fastLoginFingerprint()
    }
  }

  setDataLogin() {
    NativeBiometric.setCredentials({
      username: this.email.value!,
      password: this.password.value!,
      server: "www.example.com",
    }).then();
  }

  deleteDataLogin() {
    NativeBiometric.deleteCredentials({
      server: "www.example.com",
    }).then();
  }

  validateInputs() {
    const validate = this.email.valid && this.password.valid
    this.email.markAsTouched();
    this.password.markAsTouched();
    return validate
  }

  backCompanies() {
    this.localStorageService.remove('bernrica-store')
    this.router.navigate(['/companies'])
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
