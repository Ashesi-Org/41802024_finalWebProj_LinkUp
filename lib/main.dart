import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LinkUp());
}

class LinkUp extends StatefulWidget {
  const LinkUp({super.key});

  @override
  State<LinkUp> createState() => _LinkUpState();
}

class _LinkUpState extends State<LinkUp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LinkUp',
      home: Login()
    );
  } } // class

