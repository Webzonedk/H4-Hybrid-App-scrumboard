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
import 'dart:async';

class Board extends StatefulWidget {
  Board({required this.updateBoardState, super.key});
  OnUpdateStateOnBoard updateBoardState;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardViewController = BoardViewController();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() {
    widget.updateBoardState();
  }

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerListTitle = TextEditingController();
  final controllerTitle = TextEditingController();
//----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      child: boarding(context),
    );
  }

  Widget boarding(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    List<BoardList> lists = [];
    for (int i = 0; i < dataProvider.globalDataList.length; i++) {
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
    //Crating the lists that already have content

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
        deleteList(context, list.id),
      ],
      items: items,
      //adding a footer to apply cards with a button
      footer: addNewCard(context, list.items.length + 1),
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

//The first card called Add new list
  Widget addNewCard(BuildContext context, int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 142, 5, 194),
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Add new Card'),
            actions: <Widget>[
              TextField(
                controller: controllerTitle,
                decoration: decoration('Choose a title'),
              ),
              TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    controllerTitle.clear();
                    setState(() {});
                    Navigator.of(context).pop();
                  }),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  final listObject = BoardListObject(
                    id: (context.read<DataProvider>().globalDataList.length + 1)
                        .toString(),
                    title: controllerTitle.text,
                    items: <BoardItemObject>[],
                  );
                  context.read<DataProvider>().addToList(context, listObject);
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//Widget with a dialogbox to delete a single list and all of its cards
  Widget deleteList(BuildContext context, String index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(
          Icons.delete_forever_outlined,
          color: Color.fromARGB(255, 142, 5, 194),
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete list?'),
            content: const Text(
                'If there is card in the list, they will all be deleted. Please make sure that the list is empty before proceeding'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(174, 106, 0, 255),
                              Color.fromARGB(172, 144, 64, 255),
                              Color.fromARGB(174, 175, 118, 255),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text('Delete'),
                      onPressed: () {
                        context.read<DataProvider>().deleteList(index);

                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
