// main.dart - Tako Lansbergen 2020/02/22
//
// Hoofd-loop van de app en root-widget
// overerft van StateflessWidget

import 'package:diplomatik_app/providers/identity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diplomatik_app/pages/login_page.dart';

void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  // Root Widget van de app
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IdentityProvider>(
            create: (context) => IdentityProvider()),
      ],
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
