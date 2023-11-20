import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { BiometryType, NativeBiometric } from "capacitor-native-biometric";

@Component({
  selector: 'app-login',
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage implements OnInit {

  constructor(
    private router: Router
  ) { }

  ngOnInit() {

  }

  register() {
    this.router.navigate(['/register'])
  }

  async login() {
    const result = await NativeBiometric.isAvailable();
console.log(result);

    if (!result.isAvailable) {
      this.performRegularLogin();
      return;
    }
    const isFaceID = result.biometryType === BiometryType.FACE_ID;
    this.performBiometricVerification();
  }

  private performRegularLogin() {
    const login = true;

    if (login) {
      this.router.navigate(['/logged/home']);
    }
  }

  private async performBiometricVerification() {
    const verified = await NativeBiometric.verifyIdentity({
      reason: "For easy log in",
      title: "Log in",
      subtitle: "Maybe add subtitle here?",
      description: "Maybe a description too?",
    })
      .then(() => true)
      .catch(() => false);

    if (!verified) {
      this.performRegularLogin();
      return;
    }
    const credentials = await NativeBiometric.getCredentials({
      server: "www.example.com",
    });
    this.router.navigate(['/logged/home']);
  }

}
