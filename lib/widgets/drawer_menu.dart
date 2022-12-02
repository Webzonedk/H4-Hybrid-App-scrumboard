import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'package:date_field/date_field.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: const Color.fromARGB(255, 34, 40, 49),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 142, 5, 194),
        ),
        height: 77,
        alignment: Alignment.bottomLeft,
        child: const Text(
          'Welcome',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
        runSpacing: 5,
        children: [
          ListTile(
            leading: const Icon(Icons.border_all_rounded),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Board'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BoardScreen(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Login'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Add user'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const CreateUserSreen(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.person_search_outlined),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Get single user'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const GetUserScreen(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle_outlined),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Get all users'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const GetUsersScreen(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle_outlined),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            iconColor: const Color.fromARGB(255, 142, 5, 194),
            title: const Text('Edit user'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const CrudUserScreen(),
            )),
          ),
        ],
      );
}
