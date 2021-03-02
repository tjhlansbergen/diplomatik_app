// qualification_provider.dart - Tako Lansbergen 2020/02/24
//
// Provider voor kwalificatie-gerelateerde API-calls

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class QualificationProvider {
  // Methode voor ophalen van kwalificaties
  Future<List<Qualification>> getQualifications(BuildContext context, [bool unselected = false]) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

      // bepaal de juiste URL
      var uri = Constants.qualificationsEndpoint;
      if (unselected) {
        uri = uri + "?unselected=true";
      }

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var results = (jsonDecode(response.body) as List).map<Qualification>((q) => Qualification.fromJson(q)).toList();
        if (results != null) {
          results.sort((a, b) => a.organization.compareTo(b.organization));
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

  // Methode voor ophalen van één kwalificatie
  Future<Qualification> getQualification(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.qualificationsEndpoint + "/$id";

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var qualification = Qualification.fromJson(jsonDecode(response.body)["qualification"]);
        List<Course> courses = jsonDecode(response.body)["courses"].map<Course>((c) => Course.fromJson(c)).toList();
        if (courses != null) {
          courses.sort((a, b) => a.name.compareTo(b.name));
          qualification.courses = courses;
        }

        return qualification;
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

  // Methode voor koppelen van kwalificatie
  Future<void> addQualification(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.qualificationsEndpoint + "/$id";

      // roep endpoint asynchroon aan
      await http.patch(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }

  // Methode voor ONTkoppelen van kwalificatie
  Future<void> deleteQualification(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.qualificationsEndpoint + "/$id";

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

  // Methode voor maken van kwalificatie
  Future<void> createQualification(BuildContext context, Qualification qualification) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

      // roep endpoint asynchroon aan
      await http
          .post(Constants.qualificationsEndpoint,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(qualification.toJson()))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }
}
