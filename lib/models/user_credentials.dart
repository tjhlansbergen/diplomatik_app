class UserCredentials {
  String username;
  String password;

  UserCredentials({this.username, this.password});

  // factory UserCredentials.fromJson(Map<String, dynamic> json) {
  // 	return UserCredentials(
  // 		username: json['username'] as String,
  // 		password: json['password'] as String,
  // 	);
  // }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
