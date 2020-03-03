import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsu/month_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:statsu/pages/graph_page.dart';
import 'add_page.dart';
import 'graph_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(this.user);
  final FirebaseUser user;
  @override
  _MyHomePageState createState(){
    return _MyHomePageState(user);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(FirebaseUser _user){
    this._user = _user;
  }
  FirebaseUser _user;
  PageController _controller;
  int currentPage = DateTime.now().month -1;
  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();
    _query = Firestore.instance
            .collection("users").document(_user.email.toString()).collection("gastos")
            .where("month", isEqualTo: currentPage +1)
            .snapshots();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }
  Widget _bottomAction(IconData icon) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: () {},
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis gastos")),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Usuario'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Mi cuenta'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Configuración'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(title: Text("Cerrar Sessión"),
            onTap: () async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("/");
            },)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            //RaisedButton(onPressed: null),
            InkWell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(FontAwesomeIcons.chartPie),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new GraphPage(_user)));
      },
    ),
            SizedBox(width: 48.0),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new AddPage(_user)));
        },
      ),
      body: _body(),
    );
  }
  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if (data.hasData){
                print(data.data.documents.length);
                print(int.parse((DateTime.now().toString()).split(" ")[1].split(":")[0])-3);
                print(DateTime.now());
                return MonthWidget(
                  documents: data.data.documents);
              }
              return Center(child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            _query = Firestore.instance
            .collection('users').document(_user.email).collection("gastos")
            .where("month", isEqualTo: currentPage +1)
            .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }
  
}
