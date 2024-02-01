import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertController } from '@ionic/angular';
import { LoggedService } from './../../services/logged/logged.service';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.page.html',
  styleUrls: ['./settings.page.scss'],
})
export class SettingsPage implements OnInit {
  public showSpinner = false

  constructor(
    private alertController: AlertController,
    private router: Router,
    private loggedService: LoggedService,
  ) { }

  ngOnInit() {
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


}
