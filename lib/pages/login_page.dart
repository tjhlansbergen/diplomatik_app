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

// State van de inlogpagine, met opgegeven inloggegevens en eventuele foutmelding
class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = "";

  // build methode van de pagina
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // toon balk met app-naam
      appBar: AppBar(
        title: Text("Diplomatik"),
      ),
      body: Column(
        // centreer widgets
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // invoervelden voor gebruikernaam/wachtwoord
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Gebruikersnaam', hintText: 'Voer uw gebruikersnaam in'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Wachtwoord', hintText: 'Voer uw wachtwoord in'),
            ),
          ),
          Container(
            // inlogknop, roept _login() methode aan
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: FlatButton(
              onPressed: _login,
              child: Text(
                'Inloggen',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Padding(
            // ruimte voor het tonen van foutmelding, standaard leeg
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Text(_message, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // variablen met ingevoerde gegevens legen bij sluiten inlogpagina,
  // door de dispose methode te overriden
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // private async methode voor inloggen op de API
  Future<void> _login() async {
    // verberg keyboard
    FocusScope.of(context).unfocus();

    // roep identity provider aan om gebruiker op te halen
    // met de opgegeven inloggevens, en wacht daarop
    var identityProvider = context.read<IdentityProvider>();
    //var result = await identityProvider.fetchUser(
    //  usernameController.text, passwordController.text);

    identityProvider.getIdentity(_usernameController.text, _passwordController.text).then((_) {
      // inloggen gelukt,
      // wachtwoordveld legen
      _passwordController.clear();

      // eventueel eerder getoonde foutmelding legen
      setState(() {
        _message = "";
      });

      // en toon de de home-page
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    }).catchError((error) {
      // inloggen niet gelukt,
      // wachtwoordveld legen
      _passwordController.clear();

      // en toon foutmelding, error tekst komt van de identity-provider
      setState(() {
        _message = "Inloggen mislukt, " + error;
      });
    });
  }
}
