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

//Object to fill into empty DB to avoid error if the collection is empty
  late BoardListObject initializingListObject = BoardListObject(
    id: '0',
    title: 'new list',
    items: [],
  );

  buildListFromProvider() {
    if (globalDataList.isEmpty) {
      initializeEmptyDB(initializingListObject);
      getBoardListObjectsFromDB();
    }
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
    print(".......... Gettingthe list in provider..........");
    // ignore: avoid_print
    print(tempDataList[0].title);
    globalDataList = tempDataList;
    return globalDataList;
  }

//Posting to Firebase (Should be moved to dataprovider at some point)
  Future initializeEmptyDB(BoardListObject list) async {
    final docListObject =
        await FirebaseFirestore.instance.collection('lists').doc(list.id);

    final json = list.toJson();
    await docListObject.set(json);
  }

//Posting a new list to Firebase
  Future addToList(BuildContext context, BoardListObject list) async {
    final docListObject = FirebaseFirestore.instance
        .collection('lists')
        .doc((context.read<DataProvider>().globalDataList.length).toString());
    list.id = docListObject.id;
    final json = list.toJson();
    await docListObject.set(json);
  }

//Deletes a specific list with the document neama applied
  Future deleteList(String index) async {
    // final docList = FirebaseFirestore.instance.collection('lists').doc(index);
    // docList.delete();
    // ignore: avoid_print
    print("................. Data provider DeleteList, index.................");
    // ignore: avoid_print
    print(index);
    // ignore: avoid_print
    print(
        "................. Data provider DeleteList, globalDataList length before remove.................");
    // ignore: avoid_print
    print(globalDataList.length);

    globalDataList.removeWhere((item) => item.id == index);
    // ignore: avoid_print
    print(
        "................. Data provider DeleteList, globalDataList length after remove.................");
    // ignore: avoid_print
    print(globalDataList.length);
    await reorganizeGlobalListAndFirestore();
  }

//Reorganizing the GlobalDatalist so objects id = index
  Future reorganizeGlobalListAndFirestore() async {
    await deleteAllListInFirestore();
    for (var i = 0; i < globalDataList.length; i++) {
      globalDataList[i].id == i.toString();
      await addToListAfterReorganizing(globalDataList[i]);
      // ignore: avoid_print
      print(
          "................. Data provider ReorganizingGlobalList, globalDataList length.................");
      // ignore: avoid_print
      print(globalDataList.length);
    }
  }

  //Method to delete all documents in a collection
  Future deleteAllListInFirestore() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('lists');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    // ignore: avoid_print
    print(
        "................. Deleting all documents in Firestore.................");
  }

  //Posting a new list after reorganizing the globalDataList, to Firebase
  Future addToListAfterReorganizing(BoardListObject list) async {
    // reference to firebase document
    final docListObject =
        FirebaseFirestore.instance.collection('lists').doc(list.id);
    list.id = docListObject.id;
    final json = list.toJson();
    await docListObject.set(json);
    // ignore: avoid_print
    print(
        "................. Data provider addToListAfterReorganizing, globalDataList length.................");
    // ignore: avoid_print
    print(globalDataList.length);
  }
}
