import 'package:flutter/material.dart';
import 'package:quito_1/sidedrawer.dart';
import 'newproject.dart';

class OpenScreen extends StatefulWidget {
  OpenScreen({Key key}) : super(key: key);
  @override
  _OpenScreenState createState() => _OpenScreenState();
} 

class _OpenScreenState extends State<OpenScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Hero(
          tag:'navdrawer',
          child: SideDrawer()
        ),
        appBar: AppBar(
          title: Text('Welcome'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Start something new today',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0
                )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context){
                  return NewProject();
                }
              )
            );
          },
          tooltip: 'New Event',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


// Icon icon = Icon(Icons.person);
//         if (!(contact["image"] == "image-url")){
//           icon = Image.network(contact["image"]);
//         }