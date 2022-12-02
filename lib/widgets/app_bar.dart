import 'package:boardview/boardview_controller.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
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

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({super.key});

  // String callBackText;
  // VoidCallback updateBoardState;

  @override
  Size get preferredSize => const Size.fromHeight(50);

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerTitle = TextEditingController();

//----------------------------------------------

  /// A custom appBar to give access to the drawer, and other menu items
  @override
  Widget build(BuildContext context) => AppBar(
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
                      context
                          .read<DataProvider>()
                          .addToList(context, listObject);
                      //Accessing the  callBack function
                      //this.widget.updateBoardState(controllerTitle.text);
                      controllerTitle.clear();
                      //setState(() {});
                      // Board.mySetState();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BoardScreen()));

                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

//Additional decoration for the textField
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
