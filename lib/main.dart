// main.dart - Tako Lansbergen 2020/02/22
//
// Hoofd-loop van de app en root-widget
// overerft van StateflessWidget

import 'package:flutter/material.dart';
import 'package:diplomatik_app/pages/login_page.dart';

void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  // Root Widget van de app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diplomatik',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
