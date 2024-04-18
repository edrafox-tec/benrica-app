import 'package:benrica/routes.dart';
import 'package:benrica/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const MaterialColor(0xFF79ECC3, <int, Color>{
          50: Color(0xFFE2F7F1),
          100: Color(0xFFB5E8D9),
          200: Color(0xFF85DAC1),
          300: Color(0xFF55CCAA),
          400: Color(0xFF32C196),
          500: Color(0xFF0FB781),
          600: Color(0xFF0CAE76),
          700: Color(0xFF089B6A),
          800: Color(0xFF05885F),
          900: Color(0xFF02654C),
        }),
        fontFamily: 'Lato',
      ),
      routerDelegate: routes.routerDelegate,
      routeInformationParser: routes.routeInformationParser,
      routeInformationProvider: routes.routeInformationProvider,
    );
  }
}
