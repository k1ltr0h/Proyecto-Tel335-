import 'package:flutter/material.dart';
import 'package:statsu/pages/home_page.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:pie_chart/pie_chart.dart';



class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Map<String, double> dataMap = new Map();
      dataMap.putIfAbsent("Flutter", () => 5);
      dataMap.putIfAbsent("React", () => 3);
      dataMap.putIfAbsent("Xamarin", () => 2);
      dataMap.putIfAbsent("Ionic", () => 2);
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de gastos'),
        backgroundColor: Colors.greenAccent,
      ),
      body:
        PieChart(dataMap: dataMap) 
    );
  }
}


