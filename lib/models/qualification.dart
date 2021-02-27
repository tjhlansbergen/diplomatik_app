// qualifiation.dart - Tako Lansbergen 2020/02/24
//
// Model voor een kwalifiatie

import 'dart:ui';

import 'package:diplomatik_app/models/course.dart';

class Qualification {
  // Properties
  int id;
  String name;
  String organization;
  int qualificationTypeId;
  String createdAt;
  String updatedAt;
  List<Course> courses;

  // Constructor
  Qualification({
    this.id,
    this.name,
    this.organization,
    this.qualificationTypeId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Qualification(id: $id, name: $name, organization: $organization, qualificationTypeId: $qualificationTypeId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Deserialisatie van JSON
  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      id: json['id'] as int,
      name: json['name'] as String,
      organization: json['organization'] as String,
      qualificationTypeId: json['qualification_type_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  // Serialisatie naar JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organization': organization,
      'qualification_type_id': qualificationTypeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  bool operator ==(Object o) =>
      o is Qualification &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.organization, organization) &&
      identical(o.qualificationTypeId, qualificationTypeId) &&
      identical(o.createdAt, createdAt) &&
      identical(o.updatedAt, updatedAt);

  @override
  int get hashCode {
    return hashValues(
      id,
      name,
      organization,
      qualificationTypeId,
      createdAt,
      updatedAt,
    );
  }
}
