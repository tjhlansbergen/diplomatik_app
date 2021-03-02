// users_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor tonen van de api-gebruikers van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/providers/user_provider.dart';
import 'package:diplomatik_app/pages/user_page.dart';
import 'package:diplomatik_app/pages/user_create_page.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // asynchrone methode voor aanroepen provider voor ophalen alle gebruikers
  Future<List<User>> downloadData() async {
    var userProvider = new UserProvider();
    var response = await userProvider.getUsers(context);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("App gebruikers"),
      ),
      body: FutureBuilder<List<User>>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // wacht terwijl data binnenkomt
            return Center(child: Text('Laden...'));
          } else {
            if (snapshot.hasError)
              // toon melding indien data niet gehaald kan worden
              return Center(child: Text(snapshot.error.toString()));
            else
              // toon de data zodra deze binnen is
              return userList(context, snapshot.data);
          }
        },
      ),
      // toevoegen-knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserCreatePage()))
            .then((_) => setState(() => {})),
      ),
    );
  }

  // widget voor tonen van klikbare lijst van api-gebruikers
  Widget userList(BuildContext context, List<User> users) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
              // klik-actie voor tonen individueel item
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserPage(users[index].userId)))
                  .then((_) => setState(() => {})),
              child: SizedBox(
                  child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          users[index].userName,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "Gebruikersbeheerrechten: " + (users[index].canAddUsers ? "ja" : "nee"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
              )));
        },
        itemCount: users.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    ));
  }
}
