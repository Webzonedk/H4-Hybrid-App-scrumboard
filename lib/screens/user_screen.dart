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
        body: ListView(
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
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

//Posting to Firebase
  Future createUser(User user) async {
    // reference to firebase document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
