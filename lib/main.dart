import 'package:flutter/material.dart';
import 'package:diplomatik_app/pages/home_page.dart';

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
      home: HomePage(title: 'Diplomatik'),
    );
  }
}
