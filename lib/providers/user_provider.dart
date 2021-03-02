// user_provider.dart - Tako Lansbergen 2020/03/02
//
// Provider voor gebruikerbeheer gerelateerde API-calls

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class UserProvider {
  // Methode voor ophalen van gebruikers
  Future<List<User>> getUsers(BuildContext context) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.usersEndpoint;

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var results = (jsonDecode(response.body) as List).map<User>((q) => User.fromJson(q)).toList();
        if (results != null) {
          results.sort((a, b) => a.userName.compareTo(b.userName));
        }
        return results;
      } else {
        // alles anders 200-OK handelen we af als 'server niet bereikbaar'
        throw 'server niet bereikbaar';
      }
    } on Exception {
      // wanneer er zich een probleem voordoet bij het aanroepen van de server,
      // meldt dan dat deze niet bereikbaar is
      throw 'server niet bereikbaar';
    }
  }

  // Methode voor ophalen van één gebruiker
  Future<User> getUser(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.usersEndpoint + "/$id";

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        // alles anders 200-OK handelen we af als 'server niet bereikbaar'
        throw 'server niet bereikbaar';
      }
    } on Exception {
      // wanneer er zich een probleem voordoet bij het aanroepen van de server,
      // meldt dan dat deze niet bereikbaar is
      throw 'server niet bereikbaar';
    }
  }

  // // Methode voor toevoegen van gebruiker
  // Future<void> updateUser(BuildContext context, int id, Set<int> qualifications) async {
  //   try {
  //     var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
  //     var uri = Constants.studentsEndpoint + "/$id";
  //     var qualificationIds = {"qualification_ids": qualifications.toList()};

  //     // roep endpoint asynchroon aan
  //     await http
  //         .patch(uri,
  //             headers: {
  //               'Authorization': 'Bearer $token',
  //               "content-type": "application/json",
  //             },
  //             body: jsonEncode(qualificationIds))
  //         .timeout(Duration(seconds: Constants.defaultTimeout));

  //     // fire and forget, we wachten niet op het eventuele resultaat,
  //     // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
  //   } on Exception {
  //     // vang exceptions af en negeer ze
  //   }
  // }

  // Methode voor verwijderen van gebruiker
  Future<void> deleteUser(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.usersEndpoint + "/$id";

      // roep endpoint asynchroon aan
      await http.delete(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }

  // Methode voor maken van gebruiker
  Future<void> createUser(BuildContext context, User user) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

      // roep endpoint asynchroon aan
      await http
          .post(Constants.usersEndpoint,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(user.toJson()))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }
}
