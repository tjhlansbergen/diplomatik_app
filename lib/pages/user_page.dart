// user_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor tonen van één api gebruiker van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/providers/user_provider.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class UserPage extends StatefulWidget {
  final int _id;

  const UserPage(this._id);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // asynchrone methode voor aanroepen provider voor ophalen user
  Future<User> downloadData() async {
    var userProvider = new UserProvider();
    var response = await userProvider.getUser(context, widget._id);
    return Future.value(response);
  }

  // asynchrone methode voor aanroepen provider voor verwijderen user
  Future<void> removeUser(int id) async {
    var userProvider = new UserProvider();
    await userProvider.deleteUser(context, id);

    // if (id == Provider.of<IdentityProvider>(context, listen: false).currentUser.userId) {
    //   // gebruiker verwijderd zichzelf, log direct uit
    //   Navigator.of(context).popUntil((route) => route.isFirst);
    // } else {
    // gebruiker verwijder andere gebruiker, sluit pagina
    Navigator.pop(context);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("App gebruiker"),
      ),
      body: FutureBuilder<User>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          // wacht terwijl de data binnenkomt
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Laden...'));
          } else {
            // toon melding indien data niet gehaald kon worden
            if (snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else
              return Column(
                children: [
                  // toon data en verwijder-knop zodra de data binnen is
                  UserCard(snapshot.data),
                  // toon verwijder knop alleen voor andere gebruikers
                  if (snapshot.data.userId != Provider.of<IdentityProvider>(context, listen: false).currentUser.userId)
                    FlatButton(
                        onPressed: () => removeUser(snapshot.data.userId),
                        child: Text('App gebruiker verwijderen',
                            style: TextStyle(
                              color: Colors.red,
                            ))),
                ],
              );
          }
        },
      ),
    );
  }
}

// widget voor het tonen van één user
class UserCard extends StatelessWidget {
  final User _user;
  const UserCard(this._user);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  // toon details in kolom
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Naam:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(_user.userName,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Gebruikerbeheerrechten:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _user.canAddUsers ? "Ja" : "Nee",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ))));
  }
}
