import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ModalServiceDetailsComponent } from 'src/app/Components/modal-service-details/modal-service-details.component';
import { companyResponseInterface, serviceInterface, serviceResponseInterface } from 'src/app/models/interfacesResponse';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';
import { LoggedService } from 'src/app/services/logged/logged.service';
import { ServiceService } from './../../services/service/service.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.page.html',
  styleUrls: ['./home.page.scss'],
})
export class HomePage implements OnInit {
  public listServices: serviceInterface[] = []
  public store: companyResponseInterface = this.localStorageService.getEncrypt('bernrica-store')
  public showSpinner = false

  constructor(
    private serviceService: ServiceService,
    private localStorageService: LocalStorageService,
    private loggedService: LoggedService,
    private modalController: ModalController,
  ) { }

  ngOnInit() {
    this.store = this.localStorageService.getEncrypt('bernrica-store')
    this.listingQuestions()
  }

  async listingQuestions() {
    try {
      this.showSpinner = true
      const resp: serviceResponseInterface = await this.serviceService.getService();
      this.listServices = resp.services
      // Removendo filtro id_businesses
      // this.listServices = resp.services?.filter((item: serviceInterface) => item.id_businesses == this.store.id)
      console.log(this.listServices);

      this.showSpinner = false
    } catch (error) {
      this.showSpinner = false
      console.error(error);
      return Promise.reject(error);
    }
  }

  getRealValue(value: string) {
    return 'R$' + value.replace('.', ',')
  }

  async openModalShowDetails(service: serviceInterface) {
    const modal = await this.modalController.create({
      component: ModalServiceDetailsComponent,
      componentProps: {
        data: {
          service: service
        }
      }
    });
    await modal.present();
    await modal.onWillDismiss();
  }

}
