import { Injectable } from '@angular/core';
import { ToastController } from '@ionic/angular';
import { IToastOptions, ToastColor, ToastPosition } from '../../models/toast';

@Injectable(
  { providedIn: 'root' }
)
export class ToastService {

  public toastOptions: IToastOptions = {
    duration: 500,
    position: 'bottom',
  }

  constructor(
    public toasterController: ToastController
  ) { }

  public async showToast(): Promise<void> {
    const toast = await this.toasterController.create(this.toastOptions);
    toast.present();
  }

  public setMessage(message: string): this {
    this.toastOptions.message = message;
    return this;
  }

  public setPosition(position: ToastPosition): this {
    this.toastOptions.position = position;
    return this;
  }

  public setDuration(duration: number): this {
    this.toastOptions.duration = duration;
    return this;
  }

  public setColor(duration: ToastColor): this {
    this.toastOptions.color = duration;
    return this;
  }

  setIcon(icon: string): this {
    this.toastOptions.icon = icon;
    return this;
  }

}
