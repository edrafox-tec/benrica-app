import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ScheduleCalendarComponent } from '../schedule-calendar/schedule-calendar.component';

@Component({
  selector: 'app-modal-service-details',
  templateUrl: './modal-service-details.component.html',
  styleUrls: ['./modal-service-details.component.scss'],
})
export class ModalServiceDetailsComponent implements OnInit {
  @Input() data: any;
  public showSpinner = false;

  constructor(
    private modalController: ModalController
  ) { }

  ngOnInit() {
    console.log(this.data);

  }

  closeModal() {
    this.modalController.dismiss();
  }
  getRealValue(value: string) {
    return 'R$' + value.replace('.', ',')
  }

  async openModalScheduleCalendarComponent() {
    const modal = await this.modalController.create({
      component: ScheduleCalendarComponent,
      componentProps: {
        data: {
          // service: service
        }
      }
    });
    await modal.present();
    await modal.onWillDismiss();
  }

}
