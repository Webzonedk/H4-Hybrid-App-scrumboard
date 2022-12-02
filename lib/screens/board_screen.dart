import 'dart:io';

import 'package:boardview/boardview_controller.dart';

import 'package:date_field/date_field.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
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
import 'dart:async';

typedef OnUpdateState = void Function(String c);
typedef OnUpdateStateOnBoard = void Function();

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreen();
}

class _BoardScreen extends State<BoardScreen> {
  BoardViewController boardViewController = BoardViewController();
  //----------------------------------------------------------
  //----------------------------------------------------------
  //To be used for Push notifications
  //----------------------------------------------------------
  String? _token;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    requestPermission();
    fetchToken();
    initInfo();
    // ignore: avoid_print
    print("............ READY ..................");
    //DataProvider dataProvider = DataProvider();
  }
//--------------------------------------------------------------
//--------------------------------------------------------------

  Future<void> setNewState(String c) async {
    // ignore: avoid_print
    print("................. setNewState value of c.................");
    // ignore: avoid_print
    print(c);
    setState(() {});
  }

  Future<void> setNewStateBoard() async {
    // ignore: avoid_print
    print("................. setNewState value of d.................");
    // ignore: avoid_print
    print('test');
    setState(() {});
  }

  //  List<BoardItemObject> getCards() {
  //   const data = [
  //     {"title": "test 1"},
  //     {"title": "test 2"},
  //     {"title": "test 3"},
  //     {"title": "test 4"},
  //     {"title": "test 5"},
  //     {"title": "test 6"},
  //   ];
  //   return data.map<BoardItemObject>(BoardItemObject.fromJson).toList();
  // }

  // final List<BoardListObject> _listData = [];

//----------------------------------------------
//Added to allow editing the text for a new list
  final controllerTitle = TextEditingController();
//----------------------------------------------

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar:
            CustomAppBar(updateState: setNewState), //The appBar from widgets
        // DataProvider dataProvider =
        //     Provider.of<DataProvider>(context, listen: false);
        //Could be a streambuilder to live update
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
          child: FutureBuilder(
            future: context.read<DataProvider>().getBoardListObjectsFromDB(),
            builder: (context, snapshot) {
              if (context.read<DataProvider>().globalDataList.isEmpty) {
                context.read<DataProvider>().initializeEmptyDB(
                    context.read<DataProvider>().initializingListObject);
                return const Center(child: CircularProgressIndicator());
              } else if (context
                  .read<DataProvider>()
                  .globalDataList
                  .isNotEmpty) {
                return Board(
                    updateBoardState:
                        setNewStateBoard); //Returning the board Widget
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );

//--------------------------------------------------------------
//--------------------------------------------------------------
//Push notifications
//--------------------------------------------------------------
  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        // ignore: avoid_print
        print("....... User granted permission....");
        break;
      case AuthorizationStatus.provisional:
        // ignore: avoid_print
        print("....... User granted provisional permission....");
        break;
      default:
        // ignore: avoid_print
        print("....... User denied permission....");
        break;
    }
  }

  Future<void> fetchToken() async {
    await FirebaseMessaging.instance
        .getToken()
        // ignore: avoid_print
        .then((token) => {_token = token, print("Token: $_token")});

    //save the token to Firebase live database
    String? modelInfo = Platform.isAndroid
        ? (await fetchModelInfo() as AndroidDeviceInfo).model
        : (await fetchModelInfo() as IosDeviceInfo).name;

    FirebaseDatabase.instance
        .ref("usertokens")
        .child(modelInfo!)
        .set({"token": _token});
  }

  Future<BaseDeviceInfo> fetchModelInfo() async {
    if (Platform.isAndroid) {
      return await deviceInfoPlugin.androidInfo;
    }
    if (Platform.isIOS) {
      return await deviceInfoPlugin.iosInfo;
    }
    throw Exception("Only Android or IOS is supported!");
  }
  //-------------------------------------------------------------
  //-------------------------------------------------------------
}
