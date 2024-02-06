import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-forget-password',
  templateUrl: './forget-password.page.html',
  styleUrls: ['./forget-password.page.scss'],
})
export class ForgetPasswordPage implements OnInit {
  public showSpinner = false

  constructor(
    private router: Router
  ) { }

  ngOnInit() {
  }

  back() {
    this.router.navigate(['logged/change-password'])
  }

}
