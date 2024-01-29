import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-spinner',
  templateUrl: './spinner.component.html',
  styleUrls: ['./spinner.component.scss'],
})
export class SpinnerComponent implements OnInit {

  @Input() public showSpinner: any;
  @Input() public classes: any;

  constructor() { }

  ngOnInit() {
    if (this.classes === '' || this.classes === null || this.classes === undefined) {
      this.classes = 'spinner-transparent'
    }
  }

}
