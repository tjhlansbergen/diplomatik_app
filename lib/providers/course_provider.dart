// course_provider.dart - Tako Lansbergen 2020/03/01
//
// Provider voor vakken gerelateerde API-calls

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class CourseProvider {
  // Methode voor ophalen van vakken
  Future<List<Course>> getCourses(BuildContext context) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.coursesEndpoint;

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var results = (jsonDecode(response.body) as List).map<Course>((q) => Course.fromJson(q)).toList();
        if (results != null) {
          results.sort((a, b) => a.name.compareTo(b.name));
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

  // Methode voor ophalen van één vak
  Future<Course> getCourse(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.coursesEndpoint + "/$id";

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var course = Course.fromJson(jsonDecode(response.body)["course"]);
        List<Qualification> qualifications =
            jsonDecode(response.body)["qualifications"].map<Qualification>((c) => Qualification.fromJson(c)).toList();
        if (qualifications != null) {
          qualifications.sort((a, b) => a.organization.compareTo(b.organization));
          course.qualifications = qualifications;
        }

        return course;
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
  Future<void> updateCourse(BuildContext context, int id, Set<int> qualifications) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.coursesEndpoint + "/$id";
      var qualificationIds = {"qualification_ids": qualifications.toList()};

      // roep endpoint asynchroon aan
      await http
          .patch(uri,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(qualificationIds))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }

  // Methode voor verwijderen van vak
  Future<void> deleteCourse(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.coursesEndpoint + "/$id";

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

  // Methode voor maken van vak
  Future<void> createCourse(BuildContext context, Course course) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

      // roep endpoint asynchroon aan
      await http
          .post(Constants.coursesEndpoint,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(course.toJson()))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }
}
