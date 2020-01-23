import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatelessWidget{
  final nickName = TextEditingController();
  final passWord = TextEditingController();

  void validate() async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: nickName.text,
            password: passWord.text,
          ))
        .user;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
      children:<Widget>[ 
        TextFormField(
          controller: nickName,
          decoration: InputDecoration(
          labelText: 'username'),
          validator: (value) =>value.isEmpty ? "no se pue'e": null
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: passWord,
          decoration: InputDecoration(
          labelText: 'Password'),
          obscureText: true,
          validator: (value) =>value.isEmpty ? "no se pue'e": null,
          ),
        const SizedBox(height: 30),
        RaisedButton(
        child: Text("Register"),
        onPressed: (){
          validate();
          Navigator.of(context).pushNamed("/login");
        },)
      ]))
    );
  } 
}