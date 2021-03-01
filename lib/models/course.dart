// qualifiation.dart - Tako Lansbergen 2020/02/28
//
// Model voor een vak

import 'dart:ui';

import 'package:diplomatik_app/models/qualification.dart';

class Course {
  // Properties
  int id;
  String name;
  String code;
  int customerId;
  String createdAt;
  String updatedAt;
  List<Qualification> qualifications;

  // Constructor
  Course({
    this.id,
    this.name,
    this.code,
    this.customerId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Course(id: $id, name: $name, code: $code, customerId: $customerId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Deserialisatie van JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      customerId: json['customer_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  // Serialisatie naar JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'customer_id': customerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  bool operator ==(Object o) =>
      o is Course &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.code, code) &&
      identical(o.customerId, customerId) &&
      identical(o.createdAt, createdAt) &&
      identical(o.updatedAt, updatedAt);

  @override
  int get hashCode {
    return hashValues(
      id,
      name,
      code,
      customerId,
      createdAt,
      updatedAt,
    );
  }
}
