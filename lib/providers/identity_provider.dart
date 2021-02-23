import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/models/user_credentials.dart';
import 'package:diplomatik_app/common/constants.dart';

class IdentityProvider extends ChangeNotifier {
  User currentUser;

  Future<User> fetchUser() async {
    try {
      var credentials =
          UserCredentials(username: "inge@rotterdam.nl", password: "novi!0033");

      final response = await http.post((Constants.baseURL + "login"),
          headers: <String, String>{
            "content-type": "application/json",
          },
          body: credentials.toJson());
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
  }
}
