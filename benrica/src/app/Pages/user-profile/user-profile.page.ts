import { Component, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { AlertController } from '@ionic/angular';
import { userResponseInterface } from 'src/app/models/interfacesResponse';
import { LoggedService } from 'src/app/services/logged/logged.service';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.page.html',
  styleUrls: ['./user-profile.page.scss'],
})
export class UserProfilePage implements OnInit {
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

  public user_name = new FormControl('', [
    Validators.required,
    Validators.minLength(3),
    Validators.pattern(/^[a-zA-ZÀ-ÿ\s']+$/)
  ]);

  public email = new FormControl('', [
    Validators.required,
    Validators.minLength(3),
    Validators.email
  ]);

  public phone_number = new FormControl('', [
    Validators.required,
    Validators.minLength(11),
    Validators.maxLength(11),
    Validators.pattern(/^[0-9]+$/)
  ]);

  constructor(
    private alertController: AlertController,
    private router: Router,
    private loggedService: LoggedService,
  ) { }

  ngOnInit() {
    this.user = this.loggedService.getUser()
    this.user_name.setValue(this.user.user_name)
    this.email.setValue(this.user.email)
    this.phone_number.setValue(this.user.phone_number.toString())

  }

  back() {
    this.router.navigate(['logged/settings'])
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

  editUser() {

  }

}