
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
} 

class _MyHomePageState extends State<MyHomePage> {
  void createNewEvent() {
    Navigator.pushNamed(context, 'new');
  }

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
        onPressed: createNewEvent,
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