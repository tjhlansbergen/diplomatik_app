// qualification_provider.dart - Tako Lansbergen 2020/02/24
//
// Provider voor kwalificatie-gerelateerde API-calls
// overerft van ChangeNotifier

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class QualificationProvider extends ChangeNotifier {
  // Properties
  //List<Qualification> qualifications;

  // Methode voor ophalen van kwalificaties
  Future<List<Qualification>> getQualifications(BuildContext context) async {
//    try {
    var token =
        Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

    // roep login endpoint asynchroon aan
    final response = await http.get(Constants.qualificationsEndpoint, headers: {
      'Authorization': 'Bearer ${token}',
    });

    // check de response, deserialiseer de gegevens indien OK
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((q) => Qualification.fromJson(q))
          .toList();
    } else {
      //   // alles anders 200-OK handelen we af als 'server niet bereikbaar'
      throw 'server niet bereikbaar';
    }
    // } on Exception {
    //   // wanneer er zich een probleem voordoet bij het aanroepen van de server,
    //   // meldt dan dat deze niet bereikbaar is
    //   throw Future.error("server niet bereikbaar");
    // }
  }
}
