import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:box/firestore.dart';
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
import '../widgets/widgets.dart';

class CrudUserScreen extends StatelessWidget {
  const CrudUserScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          //title: TextField(controller: controller),
          title: const Text('Get single user'),

          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const CreateUserSreen(),
                  ),
                );
                //readUsers(name: name);
              },
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

          //FutureBuilder to read from database
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('users')
                      .doc('my-id');

                  //Update the specific field in database
                  // docUser.update({
                  //   'name': 'Emma',
                  //   //'city.name': 'San Francisco', //For nested fields
                  //   //'city.name': FieldValue.delete(), //To delete a field and its value
                  // });
                  //To replace all field in document use the following
                  docUser.set({
                    'name': 'James',
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Delete'),
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('users')
                      .doc('my-id');
                  docUser.delete();
                },
              ),
            ],
          ),
        ),
      );
}
