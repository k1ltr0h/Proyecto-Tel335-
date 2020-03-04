import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsu/pages/budget_page.dart';
import 'home_page.dart';

class Walletpage extends StatefulWidget{
  Walletpage(this._user, this.month);
  final FirebaseUser _user;
  final int month;
  @override
  _WalletpageState createState() => _WalletpageState(_user,month);
}
  
class _WalletpageState extends State<Walletpage> {
  _WalletpageState(FirebaseUser _user, int _month){
    user = _user;
    month = _month;
  }
  final tag = TextEditingController();
  FirebaseUser user;
  int month;
  int value = 0;
  Stream<QuerySnapshot> _query;


  @override
  
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tag.dispose();
    super.dispose();
  }
  void initState() {
    super.initState();
    _query = Firestore.instance
            .collection("users").document(user.email.toString()).collection("presupuestos")
            .where("month", isEqualTo: month)
            .snapshots();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Agregar presupuesto del mes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (context) =>  MyHomePage(user)));
            },
          )
        ]
      ),
      body: _body()
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ",") {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

    Widget _body() {  
      StreamBuilder<QuerySnapshot>(stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              print("suka");
              print(data.data.documents[0]["month"].toString());
              if (data.data.documents[0]["month"] == month){
                return BudgetPage(user : user , documents : data.data.documents);
              }
              return Column(children: <Widget>[
                          _currentValue(),
                          _numpad(),
                          _submit(),
                      ],
              );
            },
          );

  }

  Widget _currentValue() {
    var realValue = value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        "\$${realValue.toStringAsFixed(0)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _submit() {
    return Builder(builder: (BuildContext context) {
      return Hero(
        tag: "add_button",
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: MaterialButton(
            child: Text(
              "Agregar presupuesto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              if (value > 0) {
                var id = DateTime.now();
                Firestore.instance.collection('users').document(user.email).collection('presupuestos')
                .document(id.toString().substring(0, 20)).setData({
                "month": month,                  "presupuesto": value,
                });
                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Indique un valor")));
              }
            },
          ),
        ),
      );
    });
  }


  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 6;

        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              _num(",", height),
              _num("0", height),
              GestureDetector(
                onTap: () {
                  setState(() {
                    value = value ~/ 10;
                  });
                },
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.backspace,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ],
        );
      }),
    );
  }


}

