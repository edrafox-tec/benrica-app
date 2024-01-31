/* eslint-disable @angular-eslint/no-empty-lifecycle-method */
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LocalStorageService } from 'src/app/services/local-storage/local-storage.service';

@Component({
  selector: 'app-splash',
  templateUrl: './splash.page.html',
  styleUrls: ['./splash.page.scss'],
})
export class SplashPage implements OnInit {

  constructor(
    private router: Router,
    private localStorageService: LocalStorageService,
  ) { }

  ngOnInit() {
    setTimeout(() => {
      this.verifyNextPage()
    }, 3000);
  }

  verifyNextPage() {
    const isLoggedIn = this.localStorageService.getEncrypt('bernrica-store');
    console.log(isLoggedIn);
    if (isLoggedIn) {
      this.router.navigate(['/login'])
    } else {
      this.router.navigate(['/companies'])
    }
  }

}
