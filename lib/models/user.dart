//Object class to use for Json conversion of inputs
class User {
  String id;
  final String name;
  final int age;
  final DateTime birthDate;

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
}
