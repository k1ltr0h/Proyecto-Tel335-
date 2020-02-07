import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:statsu/pages/home_page.dart";
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_sign_in/google_sign_in.dart';

enum FormType {
  login,
  register
}

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  String email;
  String pass;
  String title = "Ingreso";
  FormType form = FormType.login;
  //FirebaseAuth.instance.


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print("wena los k");
      return true;
    }
    else{
      print("pucha la cuestión Email: $email Pass: $pass ");
      return false;
    }
  }

  Future<FirebaseUser> validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(form == FormType.login){
          print(FirebaseAuth.instance.onAuthStateChanged);
          //await FirebaseAuth.instance.setPersistence("LOCAL");
          AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
          print("Signed in: ${user.user.uid}");
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new MyHomePage(user.user)));
          return user.user;
        }
        else{
          AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
          print("Registered user: ${user.user.uid}");
          Firestore.instance.collection('users').document(user.user.email).collection('gastos');
          _showDialog(null);
          return user.user;
        }
      }
      catch(e){
        print("Error: ${e.toString().split("(")[1].split(",")[0]}");
        _showDialog(e.toString().split("(")[1].split(",")[0]);
        return null;
      }
    }
    return null;
  }

  Future<Widget> getLandingPage() async {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && (!snapshot.data.isAnonymous)) {
          return MyHomePage(_user);
        }

        return LoginPage();
      },
    );
  }

  Future<bool> isLoggedIn() async {
    this._user = await FirebaseAuth.instance.currentUser();
    if (this._user == null) {
      return false;
    }
    print("email: ${_user.email}");
    return true;
  }

  Future<void> _handleStartScreen() async {
    if (await isLoggedIn()) {
      //Navigator.of(context).pushReplacementNamed("/home");
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new MyHomePage(_user)));
    }
    else {
        print("Porfavor ingrese sus datos...");
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
   }

  void moveToRegister(){
    formKey.currentState.reset();
    setState((){
      form = FormType.register;
      title = "Registro";
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      form = FormType.login;
      title = "Ingreso";
    });
  }
  void _showDialog(String e) {
    // flutter defined function
    String _title = "";
    String _content = "";
    if(e == null){
      _title = "Todo ok!";
      _content = "Acabas de registrarte correctamente.";
    }
    else if(e == "ERROR_WRONG_PASSWORD"){
      _title = "Cuek xd";
      _content = "La contraseña ingresada es incorrecta.";
    }
    else if(e == "ERROR_EMAIL_ALREADY_IN_USE"){
      _title = "Upss";
      _content = "El e-mail ingresado ya está registrado!";
    }
    else if(e == "ERROR_USER_NOT_FOUND"){
      _title = "404";
      _content = "El e-mail ingresado no es válido.";
    }
    else if(e == "ERROR_WEAK_PASSWORD"){
      _title = "Demasiado fácil";
      _content = "Tu contraseña es muy débil, debe tener al menos 6 carácteres.";
    }
    else if(e == "ERROR_INVALID_EMAIL"){
      _title = "Formato erróneo";
      _content = "El e-mail ingresado no tiene el formato adecuado. Ej: example@example.com";
    }
    else{
      _title = "WTF!";
      _content = "La verdad no sabemos que ha sucedido, intentalo nuevamente.";
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(_title),
          content: new Text(_content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    _handleStartScreen();
    return Scaffold(
      appBar: new AppBar(title: Text(title)),
      backgroundColor: Colors.lightBlueAccent[50],
      body: Container(child: Form(
        key: formKey,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children:  buildInputs() + buildsubmitsButtons()
          )
        )
      )
    );
  }
  List<Widget> buildInputs(){
    return[
      TextFormField(
          decoration: InputDecoration(
          labelText: 'E-mail'),
          validator: (value) =>value.isEmpty ? "No debe estar vacío": null,
          onSaved: (value) => email = value,
        ),
        const SizedBox(height: 30),
        TextFormField(
          decoration: InputDecoration(
          labelText: 'Contraseña'),
          obscureText: true,
          validator: (value) =>value.isEmpty ? "No debe estar vacío": null,
          onSaved: (value) => pass = value,
          ),
    ];

  }
  List<Widget> buildsubmitsButtons(){
    if(form == FormType.login){
      return[
        RaisedButton(
            child: Text("Ingresar"),
            onPressed: (){
              //_handleSignIn();
              validateAndSubmit().then(
                (FirebaseUser user) => print(user.email))
              .catchError((e) => print(e));
              //Navigator.of(context).pushNamed("/home");
            },
          ),
          FlatButton(child: Text("Crear una cuenta", style: TextStyle(fontSize: 20),),
          onPressed: moveToRegister,)
      ];
    }
    else{
      return[
        RaisedButton(
            child: Text("Registrar"),
            onPressed: (){
              //_handleSignIn();
              validateAndSubmit().then(
                (FirebaseUser user) => print(user.email))
              .catchError((e) => print(e));
              //Navigator.of(context).pushNamed("/home");
            },
          ),
          FlatButton(child: Text("¿Ya tienes cuenta? Ingresa", style: TextStyle(fontSize: 20),),
          onPressed: moveToLogin,)
      ];
    }
  }
}