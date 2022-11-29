import '../models/models.dart';

class BoardListObject {
  late String id;
  late String title;
  late List<BoardItemObject> items;

  BoardListObject({
    required this.id,
    required this.title,
    required this.items,
  });

  // this.items = new List<BoardItemObject>();

  factory BoardListObject.fromJson(Map<String, dynamic> json) {
    return BoardListObject(
      id: json['id'],
      title: json['title'],
      items: (json['items'] is Iterable ? List.from(json['items']) : null)!,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'items': items,
      };
}
