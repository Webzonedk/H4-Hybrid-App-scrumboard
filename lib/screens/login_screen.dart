import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';
import '../models/models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          //title: TextField(controller: controller),
          title: const Text('Login'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final name = controller.text;
                createUser(name: name);
              },
            ),
          ],
        ),
      );

  Future createUser({required String name}) async {
    // reference to firebase document
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
      id: docUser.id,
      name: name,
      age: 21,
      birthDate: DateTime(2000, 9, 14),
    );
    final json = user.toJson();

    // final json = {
    //   'name': name,
    //   'age': '21',
    //   'birthday': DateTime(2001, 6, 30),
    // };

    await docUser.set(json);
  }
}
