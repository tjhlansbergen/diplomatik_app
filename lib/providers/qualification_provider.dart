// qualification_provider.dart - Tako Lansbergen 2020/02/24
//
// Provider voor kwalificatie-gerelateerde API-calls
// overerft van ChangeNotifier

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/common/constants.dart';

class QualificationProvider {
  // Properties
  //

  // Methode voor ophalen van kwalificaties
  Future<List<Qualification>> listQualifications() async {
    try {
      // roep login endpoint asynchroon aan
      final response = await http.get(Constants.qualificationsEndpoint);

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var qualifications = (jsonDecode(response.body) as List)
            .map((q) => jsonDecode(q))
            .toList();

        return qualifications;
      } else {
        throw Exception("Server error");
      }
    } on Exception {
      // wanneer er zich een probleem voordoet bij het aanroepen van de server,
      // meldt dan dat deze niet bereikbaar is
      return Future.error("server niet bereikbaar");
    }
  }
}
