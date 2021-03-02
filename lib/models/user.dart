// user.dart - Tako Lansbergen 2020/02/23
//
// Model voor een gebruiker

import 'dart:ui'; // tbv hashValues

class User {
  // Properties
  int userId;
  String userName;
  int customerId;
  String customerName;
  bool canAddUsers;
  String token;
  String password;

  // Constructor
  User({
    this.userId,
    this.userName,
    this.customerId,
    this.customerName,
    this.canAddUsers,
    this.token,
  });

  @override
  String toString() {
    return 'Identity(userId: $userId, userName: $userName, customerId: $customerId, customerName: $customerName, canAddUsers: $canAddUsers, token: $token)';
  }

  // Methode deserializatie vanaf JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'] as int,
      userName: json['username'] as String,
      customerId: json['customer_id'] as int,
      customerName: json['customer_name'] as String,
      canAddUsers: json['can_add_users'] as bool,
      token: json['token'] as String,
    );
  }

  // Serialisatie naar JSON
  Map<String, dynamic> toJson() {
    return {'id': userId, 'username': userName, 'password': password, 'can_add_users': canAddUsers};
  }

  @override
  bool operator ==(Object o) =>
      o is User &&
      identical(o.userId, userId) &&
      identical(o.userName, userName) &&
      identical(o.customerId, customerId) &&
      identical(o.customerName, customerName) &&
      identical(o.canAddUsers, canAddUsers) &&
      identical(o.token, token);

  @override
  int get hashCode => hashValues(userId, userName, customerId, customerName, canAddUsers, token);
}
