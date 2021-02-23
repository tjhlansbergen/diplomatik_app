// identity_provider.dart - Tako Lansbergen 2020/02/23
//
// Provider voor gebruiker-gerelateerde API-calls
// overerft van ChangeNotifier

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/models/user_credentials.dart';
import 'package:diplomatik_app/common/constants.dart';

class IdentityProvider extends ChangeNotifier {
  // Properties
  User currentUser;

  // Methode voor ophalen van gebruiken a.d.h.v. inloggegevens
  Future<void> fetchUser(String username, String password) async {
    try {
      // maak credentials en url
      var credentials = UserCredentials(username: username, password: password);
      var uri = Uri.http(Constants.baseURL, 'api/login');

      // roep login endpoint asynchroon aan
      final response = await http
          .post(uri,
              headers: <String, String>{
                "content-type": "application/json",
              },
              body: jsonEncode(credentials.toJson()))
          .timeout(Duration(
              seconds:
                  10)); // verkort de default timeout, inloggen mag niet langen dan 10s duren

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        currentUser = User.fromJson(jsonDecode(response.body));
        return true;
      } else {
        // wanneer er wel een respons van de server is, maar niet OK
        // meldt de gebruiker dan dat de gegevens niet kloppen
        return Future.error("inloggevens incorrect");
      }
    } on Exception {
      // wanneer er zich een probleem voordoet bij het aanroepen van de server,
      // meldt dan dat deze niet bereikbaar is
      return Future.error("server niet bereikbaar");
    }
  }
}
