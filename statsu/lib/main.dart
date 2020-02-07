import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:statsu/pages/login_page.dart';
import "pages/home_page.dart";
import 'pages/add_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Tutorial',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  FirebaseUser _user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/" : (BuildContext context) => LoginPage()
      },
    );
  }
}

