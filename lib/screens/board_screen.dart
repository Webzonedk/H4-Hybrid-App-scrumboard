import 'package:boardview/boardview_controller.dart';

import 'package:date_field/date_field.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';
import '../models/models.dart';
import 'screens.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:boardview/boardview.dart';
import '../widgets/widgets.dart';

class BoardScreen extends StatelessWidget {
  BoardScreen({super.key});

  static List<BoardItemObject> getCards() {
    const data = [
      {"title": "test 1"},
      {"title": "test 2"},
      {"title": "test 3"},
      {"title": "test 4"},
      {"title": "test 5"},
      {"title": "test 6"},
    ];
    return data.map<BoardItemObject>(BoardItemObject.fromJson).toList();
  }

  final List<BoardListObject> _listData = [
    BoardListObject(title: "test", index: 0, items: getCards()),
    BoardListObject(title: "test1", index: 1, items: getCards())
  ];

  //Can be used to animate to different sections of the BoardView
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
                    // TextButton(
                    //   onPressed: () {
                    //     final listObject = BoardListObject(
                    //       title: title,
                    //        index: index,
                    //         items: items)
                    //   }
                    //   child: const Text('OK'),
                    // ),
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
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }

    return BoardView(
      lists: _lists,
      boardViewController: boardViewController,
    );
  }

//   Widget addList() {
//     return BoardList(
//       // onStartDragList: (int? listIndex) {},
//       // onTapList: (int? listIndex) async {},
//       // onDropList: (int? listIndex, int? oldListIndex) {
//       //   //Update our local list data
//       //   var list = _listData[oldListIndex!];
//       //   _listData.removeAt(oldListIndex);
//       //   _listData.insert(listIndex!, list);
//       // },
//       headerBackgroundColor: const Color.fromARGB(255, 34, 40, 49),
//       backgroundColor: const Color.fromARGB(255, 34, 40, 49),
//       header: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(5),
//             child: IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 final name = controllerTitle.text;
//                 <Widget>[
//                   TextField(
//                     controller: controllerTitle,
//                     decoration: const InputDecoration(
//                       hintText: 'List title',
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color.fromARGB(255, 142, 5, 194),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     child: const Text('Create'),
//                     onPressed: () {
//                       final list = BoardListObject(
//                         title: controllerTitle.text,
//                         items: <BoardItemObject>[],
//                       );

// //Posting to FireBase
//                       //createUser(user);
//                       // Navigator.pop(context);
//                     },
//                   ),
//                 ];

//                 inputField();
//                 final boardListObject = BoardListObject(
//                   title: controllerTitle.text,
//                   items: <BoardItemObject>[],
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//       // items: items,
//     );
//   }

  // inputField() {
  //   TextField(
  //     controller: controllerTitle,
  //     decoration: const InputDecoration(
  //       hintText: 'List title',
  //       enabledBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           color: Color.fromARGB(255, 142, 5, 194),
  //         ),
  //       ),
  //     ),
  //   );
  // }

// Creating lists on the board to be used for listing the cards
  Widget _createBoardList(BoardListObject list) {
    //Crating the lists that already have contnt

    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
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
  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) {},
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState? state) {
          //Used to update our local item data
          var item = _listData[oldListIndex!].items[oldItemIndex!];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex!].items.insert(itemIndex!, item);
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
        ));
  }

  InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      //border: const OutlineInputBorder(),
      //fillColor: Colors.blue,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 142, 5, 194)));
  //floatingLabelStyle:
  //    const TextStyle(color: Color.fromARGB(255, 142, 5, 194)));

}
