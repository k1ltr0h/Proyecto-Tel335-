import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetPage extends StatefulWidget {
  final FirebaseUser user;
  final List<DocumentSnapshot> documents;
  final double presupuesto;
  
  BudgetPage({Key key, this.user ,this.documents}) : 
    presupuesto = documents.map((doc) => doc['money']).fold(0.0,(a,b) => a+b ),    
    super(key: key);
  @override 
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>{
  
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
