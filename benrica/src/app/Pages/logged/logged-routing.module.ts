import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AuthGuard } from 'src/app/guard/auth.guard';
import { LoggedPage } from './logged.page';

const routes: Routes = [
  {
    path: '',
    component: LoggedPage,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'home',
        loadChildren: () => import('../home/home.module').then(m => m.HomePageModule)
      },
      {
        path: 'settings',
        loadChildren: () => import('../settings/settings.module').then(m => m.SettingsPageModule)
      },
      {
        path: 'forget-password',
        loadChildren: () => import('../forget-password/forget-password.module').then(m => m.ForgetPasswordPageModule)
      },
      {
        path: 'change-password',
        loadChildren: () => import('../change-password/change-password.module').then(m => m.ChangePasswordPageModule)
      },
      {
        path: 'user-profile',
        loadChildren: () => import('../user-profile/user-profile.module').then(m => m.UserProfilePageModule)
      },

      {
        path: '',
        redirectTo: 'home',
        pathMatch: 'full'
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LoggedPageRoutingModule { }
