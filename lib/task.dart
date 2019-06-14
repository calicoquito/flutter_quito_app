import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'people.dart';

class Task extends StatefulWidget {
  Task({Key key}) : super(key: key);
  @override
  TaskState createState() => TaskState();
}

class TaskState extends State<Task> {
  TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;
  final List data = ['hey', 'how', 'hall', 'hat', 'ham', 'heap', 'help', 'health', 'hemp', 'hex', 'hack', 'hump'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'New Task',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: TextField(
                autocorrect: true,
                controller: controller,
                decoration: InputDecoration(
                    labelText: "Enter Task Name...",
                    contentPadding: EdgeInsets.all(14.0),
                    border: OutlineInputBorder()),
                onChanged: (string) {
                  setState(() {
                    textString = string;
                  });
                },
                onEditingComplete: () {
                  controller.clear();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: TextField(
                maxLines: 4,
                autocorrect: true,
                controller: controller,
                textAlign:TextAlign.justify,
                decoration: InputDecoration(
                    labelText: "Enter Task Description...",
                    contentPadding: EdgeInsets.all(14.0),
                    border: OutlineInputBorder()),
                onChanged: (string) {
                  setState(() {
                    textString = string;
                  });
                },
                onEditingComplete: () {
                  controller.clear();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: ListTile(
                leading: Text("Set As High priority"),
                trailing: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    }),
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){return People();}));
        },
      ),
    );
  }
}
