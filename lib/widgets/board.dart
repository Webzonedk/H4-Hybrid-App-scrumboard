import 'package:boardview/boardview_controller.dart';

import 'package:date_field/date_field.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../screens/screens.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:boardview/boardview.dart';
import '../widgets/widgets.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  BoardViewController boardViewController = BoardViewController();

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerTitle = TextEditingController();
//----------------------------------------------

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Scrumboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Add new list'),
                  actions: <Widget>[
                    TextField(
                      controller: controllerTitle,
                      decoration: decoration('Choose a title'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        final listObject = BoardListObject(
                          id: (context
                                      .read<DataProvider>()
                                      .globalDataList
                                      .length +
                                  1)
                              .toString(),
                          title: controllerTitle.text,
                          items: <BoardItemObject>[],
                        );
                        addToList(context, listObject);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => BoardScreen()));
                        //Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color.fromARGB(175, 82, 5, 123),
                Color.fromARGB(175, 88, 19, 185),
                Color.fromARGB(175, 127, 49, 236),
                Color.fromARGB(175, 89, 35, 251),
                Color.fromARGB(175, 25, 32, 242),
                Color.fromARGB(175, 89, 35, 251),
                Color.fromARGB(175, 127, 49, 236),
                Color.fromARGB(175, 88, 19, 185),
                Color.fromARGB(175, 82, 5, 123),
              ],
            ),
          ),
          child: boarding(context),
        ),
      );

  Widget boarding(BuildContext context) {
    List<BoardList> lists = [];
    for (int i = 0;
        i < context.read<DataProvider>().globalDataList.length;
        i++) {
      lists.add(_createBoardList(
              context, context.read<DataProvider>().globalDataList[i])
          as BoardList);
    }

    return BoardView(
      lists: lists,
      boardViewController: boardViewController,
    );
  }

// Creating lists on the board to be used for listing the cards
  Widget _createBoardList(BuildContext context, BoardListObject list) {
    //Crating the lists that already have contnt

    List<BoardItem> items = [];
    if (list.items.isNotEmpty) {}
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(context, list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = context.read<DataProvider>().globalDataList[oldListIndex!];
        context.read<DataProvider>().globalDataList.removeAt(oldListIndex);
        context.read<DataProvider>().globalDataList.insert(listIndex!, list);
      },
      headerBackgroundColor: const Color.fromARGB(255, 34, 40, 49),
      backgroundColor: const Color.fromARGB(255, 34, 40, 49),
      header: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              list.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
      ],
      items: items,
    );
  }

// Creating the cards from the list
  Widget buildBoardItem(BuildContext context, BoardItemObject itemObject) {
    return BoardItem(
      onStartDragItem:
          (int? listIndex, int? itemIndex, BoardItemState? state) {},
      onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
          int? oldItemIndex, BoardItemState? state) {
        //Used to update our local item data
        var item = context
            .read<DataProvider>()
            .globalDataList[oldListIndex!]
            .items[oldItemIndex!];
        context
            .read<DataProvider>()
            .globalDataList[oldListIndex]
            .items
            .removeAt(oldItemIndex);
        context
            .read<DataProvider>()
            .globalDataList[listIndex!]
            .items
            .insert(itemIndex!, item);
      },
      onTapItem:
          (int? listIndex, int? itemIndex, BoardItemState? state) async {},
      item: Card(
        color: const Color.fromARGB(255, 142, 5, 194),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              itemObject.title),
        ),
      ),
    );
  }
}
