// user_create_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor aanmaken nieuwe app gebruiker
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/providers/user_provider.dart';

class UserCreatePage extends StatefulWidget {
  const UserCreatePage();

  @override
  _UserCreatePageState createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State {
  final _formKey = GlobalKey<FormState>();
  List<bool> _isSelected = [true, false];

  final _name = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();

  var _user = User();

  // asynchrone methode voor aanroepen provider voor opslaan user
  Future<void> _saveUser() async {
    if (_formKey.currentState.validate()) {
      // haal veld-input op
      _formKey.currentState.save();

      // bepaal rechten
      _user.canAddUsers = _isSelected[1] ? true : false;

      // roep API aan via provider om user aan te maken
      var userProvider = new UserProvider();
      userProvider.createUser(context, _user);

      // sluit pagina
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Vul in om toe te voegen"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    // invoerveld naam
                    child: TextFormField(
                      controller: _name,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Nieuwe gebruikersnaam:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        if (value.length < 8) return 'Gebruikersnaam is te kort';
                        if (value.contains(' ')) return 'Spaties niet toegestaan';
                        return null;
                      },
                      onSaved: (value) => _user.userName = value,
                    )),
                Padding(
                    // invoerveld wachtwoord
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Nieuw wachtwoord:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        if (value.contains(' ')) return 'Spaties niet toegestaan';
                        if (value.length < 8) return 'Wachtwoord is te kort';
                        if (value != _passwordConfirmation.text) return 'Wachtwoorden komen niet overeen!';
                        return null;
                      },
                      onSaved: (value) => _user.password = value,
                    )),
                Padding(
                    // invoerveld wachtwoord bevestiging
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordConfirmation,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Bevestig wachtwoord:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        if (value.contains(' ')) return 'Spaties niet toegestaan';
                        return null;
                      },
                      onSaved: (value) => _user.password = value,
                    )),
                Padding(
                  // toggle gebruikersbeheerder
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: ToggleButtons(
                      children: <Widget>[
                        Text('  Nee  '),
                        Text('  Ja  '),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              _isSelected[buttonIndex] = true;
                            } else {
                              _isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: _isSelected,
                    ),
                  ),
                ),
              ],
            ),
          )),
      // accoordeer knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveUser,
      ),
    );
  }
}
