import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statsu/graph_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "pages/add_page.dart";

class MonthWidget extends StatefulWidget {
  final FirebaseUser user;
  final List<DocumentSnapshot> documents;
  final List<double> moneyPerDay;
  final double total;
  final Map<String, double> categories;
  
  MonthWidget({Key key, this.user ,this.documents}) : 
    total = documents.map((doc) => doc['money']).fold(0.0,(a,b) => a+b ),
    moneyPerDay =  List.generate(30, (int index){
      return documents.where((doc) => doc['day'] == (index +1 ))
      .map((doc) => doc['money'])
      .fold(0.0,(a,b) => a+b);
    }),
    categories = documents.fold({}, (Map<String, double> map, document){
      if(!map.containsKey(document['category'])){
        map[document['category']] = 0.0;
      }
      map[document['category']] += document['money'];
      return map;
    }),

    
    super(key: key);

  @override 
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
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
        Text("\$${ widget.total.toStringAsFixed(0)} ",
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
        data: widget.moneyPerDay,
        ),
    );
  }
  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.documents.length,
        itemBuilder: (BuildContext context, int index){
          var key = widget.documents[index]["category"];
          var tag = widget.documents[index]["tag"];
          if (tag == ""){tag = key;}
          var data = widget.documents[index]["money"];
          var id = widget.documents[index]["id"];
          IconData icon;
          if(key == "Compras"){icon = Icons.shopping_cart;}
          else if(key == "Cuentas"){ icon = FontAwesomeIcons.wallet;}
          else if(key == "Arriendo"){ icon = FontAwesomeIcons.home;}
          else if(key == "Locomoción"){ icon = FontAwesomeIcons.subway;}
          else if(key == "Alimentación"){ icon = FontAwesomeIcons.utensilSpoon;}
          else if(key == "Alcohol"){ icon = FontAwesomeIcons.beer;}
          else if(key == "Comida rápida"){ icon = FontAwesomeIcons.hamburger;}
          //print(index);
          return _item(icon, tag, 100*data ~/ widget.total , data.toDouble(), id); //división entera
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

  Widget _item(IconData icon, String name, int percent, double value, Timestamp id) {
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
      onTap: (){
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
                    onTap: () => {
                      //print(id),
                      _selectedFromMenu('delete', id)

                      }
                  ),
                  ListTile(
                    leading: Icon(Icons.build),
                    title: Text('Modificar'),
                    onTap: () => _selectedFromMenu('modify', id)
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

  void _selectedFromMenu(String choise, Timestamp id) async{
    Navigator.pop(context);
    try{
      if (choise == 'delete'){      
        //print(id.toDate());
        await Firestore.instance.collection('users').document(widget.user.email).collection('gastos')
        .document(id.toDate().toString().substring(0, 20)).delete();
      }
    }catch(e){
      print("No apretes tan rápido"+e.toString());
    }
    if (choise == 'modify'){
      print('modificar');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new AddPage(widget.user, id.toDate())));
    }
  }

} //end of class _MonthWidgetState