import { ComponentFixture, TestBed } from '@angular/core/testing';
import { LoggedPage } from './logged.page';

describe('LoggedPage', () => {
  let component: LoggedPage;
  let fixture: ComponentFixture<LoggedPage>;

  beforeEach(async(() => {
    fixture = TestBed.createComponent(LoggedPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
