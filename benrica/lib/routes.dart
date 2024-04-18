import 'package:benrica/screens/all_companies.dart';
import 'package:benrica/screens/change_password.dart';
import 'package:benrica/screens/forgot_password.dart';
import 'package:benrica/screens/logged_page.dart';
import 'package:benrica/screens/login_page.dart';
import 'package:benrica/screens/register_page.dart';
import 'package:benrica/screens/splash_page.dart';
import 'package:benrica/service/auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = AuthService();

final routes = GoRouter(
  initialLocation: '/companies',
  refreshListenable: authService,

  // redirect: (BuildContext context, GoRouterState state) {
  //   print('valor');
  //   print(state.uri);
  //   return null;
  //   // final isAuthenticated = authService.isAuthenticated;
  //   // final isLoginRoute = state.fullPath == '/login';
  //   // if (!isAuthenticated) {
  //   //   return isLoginRoute ? null : '/login';
  //   // }

  //   // if (isLoginRoute) return '/logged';

  //   // return null;
  // },
  routes: [
    GoRoute(
      path: '/companies',
      builder: (context, state) {
        return const CompaniesPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const CompaniesPage();
      },
    ),
    GoRoute(
      path: '/companies/:storeName',
      builder: (context, state) {
        final companyName = state.pathParameters['storeName'];
        return CompaniesPage(companyName: companyName);
      },
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return SplashPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/logged',
      builder: (context, state) {
        return LoggedPage();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) {
        return const ChangePassword();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        return const ForgotPassword();
      },
    ),
  ],
);
