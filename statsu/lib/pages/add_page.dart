import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:statsu/category_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statsu/pages/home_page.dart';

class AddPage extends StatefulWidget {
  AddPage(this._user, this.date);
  final FirebaseUser _user;
  final DateTime date;
  @override
  _AddPageState createState() => _AddPageState(_user, date);
}

class _AddPageState extends State<AddPage> {
  _AddPageState(FirebaseUser user, DateTime date){
    _user = user;
    this.date = date;
  }
  FirebaseUser _user;
  Stream<QuerySnapshot> _query;
  final tag = TextEditingController();
  String category = "Compras";
  int value = 0;
  DateTime date;

  @override
  
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tag.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Categorías",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (context) =>  MyHomePage(_user)));
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _tagInput(),
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }
  Widget _tagInput(){
    return Container(
      
      child: new TextFormField(
          decoration: new InputDecoration(
            labelText: "Tag (opcional)",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(100.0),
              borderSide: new BorderSide(
              ),
            ), 
          ),
          controller: tag));
  }
  Widget _categorySelector() {
    return Container(
      height: 110.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CategorySelectionWidget(
        categories: {
          "Compras": Icons.shopping_cart,
          "Cuentas": FontAwesomeIcons.wallet,
          "Arriendo": FontAwesomeIcons.home,
          "Locomoción" : FontAwesomeIcons.subway,
          "Alimentación" :FontAwesomeIcons.utensilSpoon,
          "Alcohol": FontAwesomeIcons.beer,
          "Comida rápida": FontAwesomeIcons.hamburger,
          
        },
        onValueChanged: (newCategory) => category = newCategory,
        
      ),
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
              "Agregar gasto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              if (value > 0 && category != "") {
                Firestore.instance.collection('users').document(_user.email).collection('gastos')
                .document(date.toString().substring(0, 20)).setData({
                "category": category,
                "money": value,
                "month": date.month,
                "day": date.day,
                "id": date,
                "tag": tag.text
                });

                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Seleccione una valor y categoría")));
              }
            },
          ),
        ),
      );
    });
  }
}