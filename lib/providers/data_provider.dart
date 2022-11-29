import 'package:box/firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'package:flutter/src/rendering/box.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

class DataProvider with ChangeNotifier {
  //final FirebaseFirestore _dbReference = FirebaseFirestore.instance.collection('lists');

  late List<BoardListObject> globalDataList = [];
  //List<BoardListObject> get globalDataList => localDataList;
  //List<BoardListObject> set globalDataList => localDataList;

  fireBaseProvider() {
    getBoardListObjectsFromDB();
  }

  // Stream<List<BoardListObject>> getBoardListObjectsFromDB1() =>
  //     FirebaseFirestore.instance.collection('lists').snapshots().map(
  //           (snapshot) => snapshot.docs
  //               .map((doc) => BoardListObject.fromJson(doc.data()))
  //               .toList(),
  //         );

  Future<List<BoardListObject>> getBoardListObjectsFromDB() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('lists').get();
    List<BoardListObject> tempDataList = snapshot.docs
        .map((doc) =>
            BoardListObject.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    // ignore: avoid_print
    print("....... testing the list in provider....");
    // ignore: avoid_print
    print(tempDataList[0].title);
    globalDataList = tempDataList;
    return globalDataList;
  }
}
