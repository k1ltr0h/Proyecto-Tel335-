import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget{
  final nickName = TextEditingController();
  final passWord = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: nickName.text,
      password: passWord.text,
    ))
        .user;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user_auth = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
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
        child: Text("Login"),
        onPressed: (){
          _handleSignIn();
          Navigator.of(context).pushNamed("/home");
        },)
      ]))
    );
  } 
}