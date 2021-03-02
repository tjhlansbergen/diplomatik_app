// home_page.dart - Tako Lansbergen 2020/02/22
//
// Hoofdpagina met menuknoppen
// overerft van StatefulWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/providers/identity_provider.dart';
import 'package:diplomatik_app/pages/qualifications_page.dart';
import 'package:diplomatik_app/pages/courses_page.dart';
import 'package:diplomatik_app/pages/students_page.dart';
import 'package:diplomatik_app/pages/users_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // header-balk met app-naam uitlogknop
        appBar: AppBar(
          title: Text("Diplomatik"),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              // raster voor de menu-knoppen
              GridView.count(shrinkWrap: true, crossAxisCount: 2, children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // menu-knop
                    child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => QualificationsPage())),
                        icon: Icon(Icons.school),
                        label: Text("Kwalificaties"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // menu-knop
                    child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoursesPage())),
                        icon: Icon(Icons.assignment),
                        label: Text("Vakken"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // menu-knop
                    child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentsPage())),
                        icon: Icon(Icons.face),
                        label: Text("Studenten"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // menu-knop
                    child: ElevatedButton.icon(
                        // schakelt accounts knop uit als ingelogde gebruiker geen gebruikersbeheerrechten heeft
                        onPressed: Provider.of<IdentityProvider>(context, listen: false).currentUser.canAddUsers
                            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => UsersPage()))
                            : null,
                        icon: Icon(Icons.supervisor_account),
                        label: Text("Accounts"))),
              ]),
              // toon naam ingelogde gebruiker en klantnaam
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Icon(Icons.person)),
                    Text(
                      Provider.of<IdentityProvider>(context, listen: false).currentUser.userName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ]),
                  Row(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Icon(Icons.location_city)),
                    Text(
                      Provider.of<IdentityProvider>(context, listen: false).currentUser.customerName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ]),
                ]),
              )
            ])));
  }
}
