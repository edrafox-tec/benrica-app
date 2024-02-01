import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

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

}
