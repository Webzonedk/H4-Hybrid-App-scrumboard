class BoardItemObject {
  final String title;

  const BoardItemObject({
    required this.title,
  });

  static BoardItemObject fromJson(json) =>
      BoardItemObject(title: json["title"]);
}
