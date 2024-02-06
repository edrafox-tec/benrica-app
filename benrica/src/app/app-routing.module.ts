import { NgModule } from '@angular/core';
import { PreloadAllModules, RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./Pages/splash/splash.module').then(m => m.SplashPageModule)
  },
  {
    path: 'login',
    loadChildren: () => import('./Pages/login/login.module').then(m => m.LoginPageModule)
  },
  {
    path: 'splash',
    loadChildren: () => import('./Pages/splash/splash.module').then(m => m.SplashPageModule)
  },
  {
    path: 'logged',
    loadChildren: () => import('./Pages/logged/logged.module').then(m => m.LoggedPageModule)
  },
  {
    path: 'register',
    loadChildren: () => import('./Pages/register/register.module').then(m => m.RegisterPageModule)
  },
  {
    path: 'companies',
    loadChildren: () => import('./Pages/companies/companies.module').then(m => m.CompaniesPageModule)
  },

];
@NgModule({
  imports: [
    RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }
