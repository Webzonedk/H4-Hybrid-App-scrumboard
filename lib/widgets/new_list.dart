import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'package:date_field/date_field.dart';

// void main() => runApp(const MyApp());

class NewListDialog extends StatelessWidget {
  NewListDialog({super.key});

  final controllerTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
      child: const Text('Show Dialog'),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      //fillColor: Colors.blue,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 142, 5, 194)),
      floatingLabelStyle:
          const TextStyle(color: Color.fromARGB(255, 142, 5, 194)));

  //         //Posting to Firebase
  // Future createList(BoardListObject boardListObject) async {
  //   // reference to firebase document
  //   final docBoardListObject = FirebaseFirestore.instance.collection('users').doc();
  //   boardListObject.title = docBoardListObject.id;
  //   final json = boardListObject.toJson();
  //   await docBoardListObject.set(json);
  // }
}
