// student.dart - Tako Lansbergen 2020/03/02
//
// Model voor een student

import 'dart:ui';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/models/course.dart';

class Student {
  // Properties
  int id;
  String name;
  String studentNumber;
  int customerId;
  String createdAt;
  String updatedAt;
  List<Qualification> qualifications;
  List<Course> exemptions;

  // Constructor
  Student({
    this.id,
    this.name,
    this.studentNumber,
    this.customerId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Student(id: $id, name: $name, studentNumber: $studentNumber, customerId: $customerId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Deserialisatie van JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      studentNumber: json['student_number'] as String,
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
      'student_number': studentNumber,
      'customer_id': customerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  bool operator ==(Object o) =>
      o is Student &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.studentNumber, studentNumber) &&
      identical(o.customerId, customerId) &&
      identical(o.createdAt, createdAt) &&
      identical(o.updatedAt, updatedAt);

  @override
  int get hashCode {
    return hashValues(
      id,
      name,
      studentNumber,
      customerId,
      createdAt,
      updatedAt,
    );
  }
}
