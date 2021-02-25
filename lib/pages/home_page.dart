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
          title: Text("Diplomatik"),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              GridView.count(
                  // raster voor de menu-knoppen
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton.icon(
                            onPressed: _buttonDummy,
                            icon: Icon(Icons.school),
                            label: Text("Kwalificaties"))),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton.icon(
                            onPressed: _buttonDummy,
                            icon: Icon(Icons.assignment),
                            label: Text("Vakken"))),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton.icon(
                            onPressed: _buttonDummy,
                            icon: Icon(Icons.face),
                            label: Text("Studenten"))),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Icon(Icons.person)),
                    Text(
                      Provider.of<IdentityProvider>(context, listen: false)
                          .currentUser
                          .userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ]),
                  Row(children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Icon(Icons.location_city)),
                    Text(
                      Provider.of<IdentityProvider>(context, listen: false)
                          .currentUser
                          .customerName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ]),
                ]),
              )
            ])));
  }

  void _buttonDummy() {
    //
  }
}
