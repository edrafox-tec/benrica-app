import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.page.html',
  styleUrls: ['./change-password.page.scss'],
})
export class ChangePasswordPage implements OnInit {
  public showSpinner = false

  constructor(
    private router: Router
  ) { }

  ngOnInit() {
  }

  back() {
    this.router.navigate(['logged/settings'])
  }

}
