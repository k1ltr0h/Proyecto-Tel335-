import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class MenuPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
      children:<Widget>[ 
        RaisedButton(
        child: Text("Sign In"),
        onPressed: (){
            Navigator.of(context).pushNamed("/login");
        },
        
      ),
      const SizedBox(height: 30),
      RaisedButton(
        child: Text("Sign up"),
        onPressed: (){
          Navigator.of(context).pushNamed("/register");
        },
        
      ),
      const SizedBox(height: 30),
      RaisedButton(
       // child: Text("Salir"),
       child: Text("Salir"),
        onPressed: ()=> SystemNavigator.pop(),
        
      ),
      ]))
    );
  } 
}