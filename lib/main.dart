import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';
import 'package:date_field/date_field.dart';

Future main() async {
  //Remember future if included methods needs to be run first
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainPage());
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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scrumboard'),
          backgroundColor: const Color.fromARGB(255, 142, 5, 194),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        drawer: const NavigationDrawer(),
      );
}
