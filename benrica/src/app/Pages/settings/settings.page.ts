import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { AlertController } from '@ionic/angular';
import { userResponseInterface } from 'src/app/models/interfacesResponse';
import { LoggedService } from './../../services/logged/logged.service';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.page.html',
  styleUrls: ['./settings.page.scss'],
})
export class SettingsPage implements OnInit {
  public showSpinner = false
  public user: userResponseInterface = {
    id: '',
    id_businesses: '',
    user_name: '',
    email: '',
    phone_number: '',
    access_level: '',
    resset_pass: null,
    deleted_at: null,
    created_at: '',
    updated_at: null
  }

  public newProfilePhoto = ''

  constructor(
    private alertController: AlertController,
    private router: Router,
    private loggedService: LoggedService,
  ) { }

  ngOnInit() {
    this.user = this.loggedService.getUser()
  }

  ionViewWillEnter() {
    this.user = this.loggedService.getUser()
  }

  exitApp() {
    this.loggedService.clear()
    this.loggedService.clearForce()
    this.loggedService.exit()
    this.router.navigate(['/login'])
  }

  async confirmationClose() {
    const alert = await this.alertController.create({
      header: 'Sair',
      message: 'Tem certeza de que deseja sair?',
      buttons: [
        {
          text: 'Sim',
          handler: () => {
            this.exitApp()
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

  back() {
    this.router.navigate(['/logged/home'])
  }

  async takePicture() {
    this.showSpinner = true
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Prompt,
      saveToGallery: false
    });
    console.log(image.dataUrl);
    this.newProfilePhoto = image.dataUrl || ''

    // Requisição mudar foto
    this.showSpinner = false
  };
}
