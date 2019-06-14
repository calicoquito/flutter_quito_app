import 'dart:math';

import 'package:flutter/material.dart';
import 'tasks.dart';

class People extends StatefulWidget {
  People({Key key}) : super(key: key);
  @override
  PeopleState createState() => PeopleState();
} 

class PeopleState extends State<People> {
  final List data = ['hey', 'how', 'hall', 'hat', 'ham', 'heap', 'help', 'health', 'hemp', 'hex', 'hack', 'hump'];
  List<bool> setval = List();

  @override
  void initState() {
    super.initState();
    getSWData();
  }

  void getSWData(){
    setState(() {
      for (var i in data) {
        setval.add(false);
      }
    });
    }


    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0,left: 4.0),
                      onTap: () {},
                      trailing: Checkbox(
                        value: setval[index],
                        onChanged: (bool value) {
                          setState(() {
                            setval[index] = value;
                          });
                        },
                      ),
                      leading: CircleAvatar(
                        child: ico,
                        radius:20.0,
                        backgroundImage:
                            NetworkImage(data[index]),
                        backgroundColor: Colors.primaries[Random().nextInt(15)],
                      ),
                      title: Text(
                          "Name: ${data[index]} ${data[index]}"),
                      subtitle: Text("Email: ${data[index]}",
                          style:
                              TextStyle(fontSize: 10.0, color: Colors.black54)),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
          title: Text(
        'Assign Task',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(child: lst(Icon(Icons.person),data)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){return TaskList();}));
        },
        tooltip: 'Create task',
        child: Icon(Icons.check),
      ),
    );
  }
}
