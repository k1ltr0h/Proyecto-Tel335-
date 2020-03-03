
import 'package:flutter/material.dart';
import 'package:statsu/pages/home_page.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';



class GraphPage extends StatelessWidget {
  GraphPage(this._user);
  final FirebaseUser _user;
  Stream<QuerySnapshot> _query;
  @override

  void initState() {
    _query = Firestore.instance
            .collection("users").document(_user.email.toString()).collection("gastos")
            .snapshots();
  }

  Widget build(BuildContext context) {
    initState();
    Map<String, double> dataMap = new Map();
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de gastos'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if (data.hasData){
                //print(data.data.documents);
                for(var i in data.data.documents){
                  print(i.data["money"]);
                  dataMap.putIfAbsent(i.data["category"], () => i.data["money"].toDouble());
                }
                return PieChart(dataMap: dataMap);
              }
            return null;
            },
          ),
      )
    );
  }
}