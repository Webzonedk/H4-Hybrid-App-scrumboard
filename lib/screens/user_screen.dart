import 'package:date_field/date_field.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';
import '../models/models.dart';
import 'screens.dart';
import 'package:flutter/src/rendering/box.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  DateTime? selectedDate;
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Add user'),
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextField(
                controller: controllerName,
                decoration: decoration('Name'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controllerAge,
                decoration: decoration('Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              DateTimeField(
                  decoration: decoration('Birthday'),
                  dateTextStyle:
                      const TextStyle(color: Color.fromARGB(255, 142, 5, 194)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  mode: DateTimeFieldPickerMode.date,
                  selectedDate: DateTime.now(),
                  onDateSelected: (DateTime value) {
                    selectedDate = value;
                  }),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () {
                  final user = User(
                    name: controllerName.text,
                    age: int.parse(controllerAge.text),
                    birthDate: selectedDate,
                  );

//Posting to FireBase
                  createUser(user);
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        //backgroundColor: Colors.black87,
      );

  InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      //fillColor: Colors.blue,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 142, 5, 194)),
      floatingLabelStyle:
          const TextStyle(color: Color.fromARGB(255, 142, 5, 194)));

//Posting to Firebase
  Future createUser(User user) async {
    // reference to firebase document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
