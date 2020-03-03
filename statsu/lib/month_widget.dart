import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statsu/graph_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonthWidget extends StatefulWidget {
  MonthWidget(this._user,this.documents);
  final FirebaseUser _user;
  final List<DocumentSnapshot> documents;
  //final List<double> moneyPerDay;
  //final double total;
  //final Map<String, double> categories;
  //MonthWidget({Key key, this.documents} ) : 
    

  @override 
  _MonthWidgetState createState() => _MonthWidgetState(_user);
}

class _MonthWidgetState extends State<MonthWidget> {
  _MonthWidgetState(FirebaseUser user){
    this._user=user;
  }
  FirebaseUser _user;
  List<DocumentSnapshot> documents;
  List<double> moneyPerDay;
  double total;
  Map<String, double> categories;
  @override
  
  void init(){
    total = documents.map((doc) => doc['money']).fold(0.0,(a,b) => a+b );
    moneyPerDay =  List.generate(30, (int index){
      return documents.where((doc) => doc['day'] == (index +1 ))
      .map((doc) => doc['money'])
      .fold(0.0,(a,b) => a+b);
    });
    categories = documents.fold({}, (Map<String, double> map, document){
      if(!map.containsKey(document['category'])){
        map[document['category']] = 0.0;
      }
      map[document['category']] += document['money'];
      return map;
    });
  }
  Widget build(BuildContext context) {
    init();
    return Expanded(
      child: Column(
        children: <Widget>[
        _expenses(),
        _graph(),
        Container(
          color: Colors.greenAccent.withOpacity(0.15),
          height: 24.0,
        ),
        _list(),
      ],
     ),
    );
  }


  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text("\$${total.toStringAsFixed(0)} ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
          ),
        ),
        Text("Gastos Totales",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    return Container(
      height: 200.0,
      child: GraphWidget(
        data: moneyPerDay,
        ),
    );
  }
  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: categories.keys.length,
        itemBuilder: (BuildContext context, int index){
          var key = categories.keys.elementAt(index);
          var data = categories[key]; 
          print("data =" +data.toString());
          print("key =" +key.toString());
          return _item(FontAwesomeIcons.shoppingCart, key, 100*data ~/ total , data); //división entera
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }

  Widget _item(IconData icon, String name, int percent, double valuedouble) {
    int value = valuedouble.round(); //elimina el decimal del valor.
    return ListTile(
      leading: Icon(icon, size: 32.0,),
      title: Text(name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      subtitle: Text("$percent% of expenses",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("\$$value",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
      
      onLongPress: (){
        showModalBottomSheet(
          context: context, 
          builder: (context) {
            return Container(
              height: 120,
              color: Color(0xFF737373),
              child: Container(
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Eliminar'),
                    onTap: () => _selectedFromMenu('delete', )
                  ),
                  ListTile(
                    leading: Icon(Icons.build),
                    title: Text('Modificar'),
                    onTap: () => _selectedFromMenu('modify')
                  )
                ]),
                
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(35),
                    topRight: const Radius.circular(35)
                  ),
                ),
              ),
            );
        });
      },
    );
  }


  void _selectedFromMenu(String choise){
    if (choise == 'delete'){
      /*
      print('eliminar');
      Firestore.instance
      .collection('users')
      .document(_user.email)
      .collection('gastos')
      .document().where
      .delete();*/
    }
    if (choise == 'modify'){
      print('modificar');
    }
    Navigator.pop(context);
  }

} //end of class _MonthWidgetState