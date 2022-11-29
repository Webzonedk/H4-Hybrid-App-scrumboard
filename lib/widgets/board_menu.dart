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

//---------------------------------
//This Widget is not currently in use
//---------------------------------
class BoardMenu extends StatefulWidget {
  const BoardMenu({super.key});

  @override
  State<BoardMenu> createState() => _BoardMenuState();
}

class _BoardMenuState extends State<BoardMenu> {
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
                        Navigator.of(context).pop();
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
        ),
      );
}

InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 142, 5, 194),
      ),
      floatingLabelStyle: const TextStyle(
        color: Color.fromARGB(255, 142, 5, 194),
      ),
    );

//Posting to Firebase
Future addToList(BuildContext context, BoardListObject list) async {
  // reference to firebase document
  final docListObject = FirebaseFirestore.instance
      .collection('lists')
      .doc((context.read<DataProvider>().globalDataList.length + 1).toString());
  list.id = docListObject.id;
  final json = list.toJson();
  await docListObject.set(json);
}
