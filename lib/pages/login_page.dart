// login_page.dart - Tako Lansbergen 2020/02/22
//
// App pagina met inlog-formulier
// overerft van StatefulWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/pages/home_page.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String _message = "";

  void _setMessage(String text) {
    setState(() {
      _message = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diplomatik"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gebruikersnaam',
                  hintText: 'Voer uw gebruikersnaam in'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Wachtwoord',
                  hintText: 'Voer uw wachtwoord in'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: FlatButton(
              onPressed: _login,
              child: Text(
                'Inloggen',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Text(_message, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Log in via de API
    var identityProvider = context.read<IdentityProvider>();
    var result = await identityProvider.fetchUser(
        usernameController.text, passwordController.text);

    // TODO juiste error tonen
    if (result == true) {
      _setMessage(""); // eventuele error tekst verwijderen
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      _setMessage("Inloggen mislukt");
    }
  }
}
