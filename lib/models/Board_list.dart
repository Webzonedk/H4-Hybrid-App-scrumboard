import 'models.dart';

class BoardListObject {
  final String title;
  final int index;
  List<BoardItemObject> items;

  BoardListObject(
      {required this.title, required this.index, required this.items});

  // this.items = new List<BoardItemObject>();
}
