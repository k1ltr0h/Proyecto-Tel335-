import 'package:flutter/material.dart';
import 'package:statsu/pages/login_page.dart';
import "pages/home_page.dart";
import "pages/register_page.dart";
import "pages/menu_page.dart";

void main() {
  runApp(MaterialApp(
    title: 'Flutter Tutorial',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/" : (BuildContext context) => MenuPage(),
        "/home" : (BuildContext context) => MyHomePage(),
        "/register" : (BuildContext context) => RegisterPage(),
        "/login" : (BuildContext context) => LoginPage()
      },
    );
  }
}

