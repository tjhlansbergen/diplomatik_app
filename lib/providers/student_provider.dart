// student_provider.dart - Tako Lansbergen 2020/03/02
//
// Provider voor student gerelateerde API-calls

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:diplomatik_app/models/student.dart';
import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/providers/identity_provider.dart';

class StudentProvider {
  // Methode voor ophalen van studenten
  Future<List<Student>> getStudents(BuildContext context) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.studentsEndpoint;

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var results = (jsonDecode(response.body) as List).map<Student>((q) => Student.fromJson(q)).toList();
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

  // Methode voor ophalen van één Student
  Future<Student> getStudent(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.studentsEndpoint + "/$id";

      // roep endpoint asynchroon aan
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: Constants.defaultTimeout));

      // check de response, deserialiseer de gegevens indien OK
      if (response.statusCode == 200) {
        var student = Student.fromJson(jsonDecode(response.body)["student"]);
        List<Qualification> qualifications =
            jsonDecode(response.body)["qualifications"].map<Qualification>((c) => Qualification.fromJson(c)).toList();
        if (qualifications != null) {
          qualifications.sort((a, b) => a.organization.compareTo(b.organization));
          student.qualifications = qualifications;
        }
        List<Course> exemptions =
            jsonDecode(response.body)["exemptions"].map<Course>((c) => Course.fromJson(c)).toList();
        if (exemptions != null) {
          exemptions.sort((a, b) => a.name.compareTo(b.name));
          student.exemptions = exemptions;
        }

        return student;
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
  Future<void> updateStudent(BuildContext context, int id, Set<int> qualifications) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.studentsEndpoint + "/$id";
      var qualification_ids = {"qualification_ids": qualifications.toList()};

      // roep endpoint asynchroon aan
      await http
          .patch(uri,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(qualification_ids))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }

  // Methode voor verwijderen van student
  Future<void> deleteStudent(BuildContext context, int id) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;
      var uri = Constants.studentsEndpoint + "/$id";

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
  Future<void> createStudent(BuildContext context, Student student) async {
    try {
      var token = Provider.of<IdentityProvider>(context, listen: false).currentUser.token;

      // roep endpoint asynchroon aan
      await http
          .post(Constants.studentsEndpoint,
              headers: {
                'Authorization': 'Bearer $token',
                "content-type": "application/json",
              },
              body: jsonEncode(student.toJson()))
          .timeout(Duration(seconds: Constants.defaultTimeout));

      // fire and forget, we wachten niet op het eventuele resultaat,
      // en laten het aan de server over om te bepalen of het request wel/niet uitgevoerd wordt
    } on Exception {
      // vang exceptions af en negeer ze
    }
  }
}
