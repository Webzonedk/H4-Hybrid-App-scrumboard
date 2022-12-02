import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';
import 'package:date_field/date_field.dart';
import 'dart:async';
import 'package:flutter/services.dart';

//------------------------------------------------------------
//------------------------------------------------------------
//Firebase Messaging
//------------------------------------------------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //ignore: avoid_print
  print("handling a background message ${message.messageId}");
}

void initInfo() {
  var androidInitialize =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitialize = const DarwinInitializationSettings(); //IOS
  var initializationsSettings =
      InitializationSettings(android: androidInitialize, iOS: iosInitialize);
  flutterLocalNotificationsPlugin.initialize(
    initializationsSettings,
    onDidReceiveNotificationResponse: ((NotificationResponse details) async {
      // ignore: avoid_print
      print(details.payload);
    }),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  FirebaseMessaging.onMessage.listen((message) async {
    // ignore: avoid_print
    print("............ onMessage.................");
    // ignore: avoid_print
    print(
        "onMessage: ${message.notification?.title}/${message.notification?.body}");
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['body'],
    );
  });
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
//------------------------------------------------------------
//------------------------------------------------------------

Future<void> main() async {
  //Remember future if included methods needs to be run first
  WidgetsFlutterBinding.ensureInitialized();
  initInfo();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const MainPage(),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrumboard',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Color.fromARGB(255, 142, 5, 194),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 142, 5, 194),
            ),
          ),
        ),
      ),
      home: BoardScreen(),
    );
  }
}
