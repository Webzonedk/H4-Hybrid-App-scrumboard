class BoardItemObject {
  final String id;
  final String title;
  final String description;
  final int points;
  final String assignedTo;

  const BoardItemObject(
      {required this.id,
      required this.title,
      required this.description,
      required this.points,
      required this.assignedTo});

  static BoardItemObject fromJson(Map<String, dynamic> json) => BoardItemObject(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        points: json["points"],
        assignedTo: json["assignedTo"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'points': points,
        'assignedTo': assignedTo,
      };
}
