import 'package:boardview/boardview_controller.dart';

import 'package:date_field/date_field.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'screens.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:boardview/boardview.dart';
import '../widgets/widgets.dart';

class BoardScreen extends StatelessWidget {
  BoardScreen({super.key});

  //DataProvider dataProvider = DataProvider();

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

  List<BoardListObject> _listData = [];

  // final List<BoardListObject> _listData = [
  //   BoardListObject(id: "0", title: "test", index: 0, items: getCards()),
  //   BoardListObject(id: "1", title: "test1", index: 1, items: getCards())
  // ];

  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = BoardViewController();

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerTitle = TextEditingController();
//----------------------------------------------

  @override
  Widget build(BuildContext context) {
    DataProvider dataList = Provider.of<DataProvider>(context, listen: false);
    return FutureBuilder(
      future: dataList.getBoardListObjectsFromDB(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // ignore: avoid_print
          print("....... data error....");
          // ignore: avoid_print
          print(snapshot.error);
        } else if (snapshot.hasData) {
          List<BoardListObject> listObjects =
              snapshot.data as List<BoardListObject>;
          _listData = listObjects;
          // ignore: avoid_print
          print("....... Board screen snapshot has data....");
          // ignore: avoid_print
          print(_listData[0].title);
          return const Board();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        // ignore: avoid_print
        print("....... Board screen testing the list....");
        // ignore: avoid_print
        print(_listData);
        return CircularProgressIndicator();
      },
    );

    // InputDecoration decoration(String label) => InputDecoration(
    //       labelText: label,
    //       border: const OutlineInputBorder(),
    //       labelStyle: const TextStyle(
    //         color: Color.fromARGB(255, 142, 5, 194),
    //       ),
    //       floatingLabelStyle: const TextStyle(
    //         color: Color.fromARGB(255, 142, 5, 194),
    //       ),
    //     );

// //Posting to Firebase
//   Future addToList(BoardListObject list) async {
//     // reference to firebase document
//     final docListObject = FirebaseFirestore.instance
//         .collection('lists')
//         .doc((_listData.length + 1).toString());
//     list.id = docListObject.id;
//     final json = list.toJson();
//     await docListObject.set(json);
//   }
  }
}
