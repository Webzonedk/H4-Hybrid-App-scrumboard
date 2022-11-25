//Object class to use for Json conversion of inputs
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final String name;
  final int age;
  final DateTime? birthDate;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthDate': birthDate,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        birthDate: (json['birthDate'] as Timestamp).toDate(),
      );
}
