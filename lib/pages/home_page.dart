// home_page.dart - Tako Lansbergen 2020/02/22
//
// Hoofdpagina met menuknoppen
// overerft van StatefulWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/providers/identity_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // header-balk met inlognaam en uitlogknop
          title: Text("Welkom " +
              Provider.of<IdentityProvider>(context, listen: false)
                  .currentUser
                  .userName),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GridView.count(
              // raster voor de menu-knoppen
              crossAxisCount: 2,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ElevatedButton.icon(
                        onPressed: _buttonDummy,
                        icon: Icon(Icons.grading),
                        label: Text("Kwalificaties"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ElevatedButton.icon(
                        onPressed: _buttonDummy,
                        icon: Icon(Icons.assignment),
                        label: Text("Vakken"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ElevatedButton.icon(
                        onPressed: _buttonDummy,
                        icon: Icon(Icons.face),
                        label: Text("Studenten"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ElevatedButton.icon(
                        onPressed: Provider.of<IdentityProvider>(context,
                                    listen: false)
                                .currentUser
                                .canAddUsers
                            ? _buttonDummy
                            : null,
                        icon: Icon(Icons.supervisor_account),
                        label: Text("Accounts"))),
              ]),
        ));
  }

  void _buttonDummy() {
    //
  }
}
