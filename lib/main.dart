// main.dart - Tako Lansbergen 2020/02/22
//
// Hoofd-loop van de app en root-widget
// overerft van StateflessWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/pages/login_page.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';

// main functie van de app, start AppRoot
void main() {
  runApp(AppRoot());
}

// root-widget van de app, alle widgets stammen hiervan af
class AppRoot extends StatelessWidget {
  // build methode van de app
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // registreer providers, voor aanroepen endpoints
      // deze maken zo tevens hun properties beschikbaar voor onderliggende widgets
      providers: [
        ChangeNotifierProvider<IdentityProvider>(
            create: (context) => IdentityProvider()),
        ChangeNotifierProvider<QualificationProvider>(
            create: (context) => QualificationProvider()),
      ],
      // root-niveau van de UI, met thema en eerst getoonde pagina (login)
      child: MaterialApp(
        title: 'Diplomatik',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      ),
    );
  }
}
