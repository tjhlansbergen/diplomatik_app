import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:diplomatik_app/models/user.dart';
import 'package:diplomatik_app/models/user_credentials.dart';
import 'package:diplomatik_app/common/constants.dart';

class IdentityProvider extends ChangeNotifier {
  User currentUser;

  Future<bool> fetchUser(String username, String password) async {
    try {
      var credentials = UserCredentials(username: username, password: password);

      var uri = Uri.http(Constants.baseURL, 'api/login');

      final response = await http.post(uri,
          headers: <String, String>{
            "content-type": "application/json",
          },
          body: jsonEncode(credentials.toJson()));

      if (response.statusCode == 200) {
        currentUser = User.fromJson(jsonDecode(response.body));
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }
}
