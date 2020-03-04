import 'package:flutter/material.dart';
import 'package:statsu/pages/login_page.dart';


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
        "/" : (BuildContext context) => LoginPage()
      },
    );
  }
}

