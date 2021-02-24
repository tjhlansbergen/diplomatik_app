// identity.dart - Tako Lansbergen 2020/02/23
//
// Model voor een gebruiker

import 'dart:ui'; // tbv hashValues

class Identity {
  // Properties
  int userId;
  String userName;
  int customerId;
  bool canAddUsers;
  String token;

  // Constructor
  Identity({
    this.userId,
    this.userName,
    this.customerId,
    this.canAddUsers,
    this.token,
  });

  // Methode voor het omzetten naar tekenreeks
  @override
  String toString() {
    return 'Identity(userId: $userId, userName: $userName, customerId: $customerId, canAddUsers: $canAddUsers, token: $token)';
  }

  // Methode deserializatie vanaf JSON object
  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      customerId: json['customer_id'] as int,
      canAddUsers: json['can_add_users'] as bool,
      token: json['token'] as String,
    );
  }

  // Override de equals methode voor het verglijken van twee User objecten
  @override
  bool operator ==(Object o) =>
      o is Identity &&
      identical(o.userId, userId) &&
      identical(o.userName, userName) &&
      identical(o.customerId, customerId) &&
      identical(o.canAddUsers, canAddUsers) &&
      identical(o.token, token);

  // Override hashcode voor het maken van hashcode van samengestelde properties
  @override
  int get hashCode =>
      hashValues(userId, userName, customerId, canAddUsers, token);
}
