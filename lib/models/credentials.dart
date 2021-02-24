// credentials.dart - Tako Lansbergen 2020/02/23
//
// POCO-klasse voor de inloggegevens van een gebruiker

class Credentials {
  // Properties
  String username;
  String password;

  // Contructor
  Credentials({this.username, this.password});

  // Methode voor serializatie naar JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
