import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Budgetpage extends StatefulWidget {
  final FirebaseUser user;
  final List<DocumentSnapshot> documents;
  final double presupuesto;
  
  Budgetpage({Key key, this.user ,this.documents}) : 
    presupuesto = documents.map((doc) => doc['money']).fold(0.0,(a,b) => a+b ),    
    super(key: key);

  @override 
  _BudgetpageState createState() => _BudgetpageState();
}

class _BudgetpageState() extends State<Budgetpage>{
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
        _expenses(),
      ],
     ),
    );
  }

  Widget _expenses() {
      return Column(
        children: <Widget>[
          Text("\$${ widget.presupuesto.toStringAsFixed(0)} ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
          Text("Presupuesto indicado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blueGrey,
            ),
          ),
        ],
      );
    }


}
