import 'package:flutter/material.dart';
import 'newproject.dart';
import 'addmembers.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
} 

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Start something new today',
              style: TextStyle(
                color: Colors.blueGrey,
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
    );
  }
}


// Icon icon = Icon(Icons.person);
//         if (!(contact["image"] == "image-url")){
//           icon = Image.network(contact["image"]);
//         }