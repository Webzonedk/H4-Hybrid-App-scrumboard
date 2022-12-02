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

  final List<BoardListObject> _listData = [];

  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = BoardViewController();

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerTitle = TextEditingController();
//----------------------------------------------

  @override
  Widget build(BuildContext context) {
    // DataProvider dataProvider =
    //     Provider.of<DataProvider>(context, listen: false);
    //Could be a streambuilder to live update
    return FutureBuilder(
      future: context.read<DataProvider>().getBoardListObjectsFromDB(),
      builder: (context, snapshot) {
        if (context.read<DataProvider>().globalDataList.isEmpty) {
          // // ignore: avoid_print
          // print("....... Board screen globalDataList is empty.......");
          // // ignore: avoid_print
          // print(snapshot.error);
          context.read<DataProvider>().initializeEmptyDB(
              context.read<DataProvider>().initializingListObject);
          return const Center(child: CircularProgressIndicator());
        } else if (context.read<DataProvider>().globalDataList.isNotEmpty) {
          // // ignore: avoid_print
          // print("....... Board screen globalDataList has data....");
          // // ignore: avoid_print
          // print(context.read<DataProvider>().globalDataList[0].title);

          return const Board(); //Returning the board Widget
        } else {
          return const Center(child: CircularProgressIndicator());
        }

        // // ignore: avoid_print
        // print("....... Board screen no error and no data. Just loading......");
        // // ignore: avoid_print
        // print(context.read<DataProvider>().globalDataList[0].title);
        // return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
