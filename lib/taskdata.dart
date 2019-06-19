import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TaskData extends StatefulWidget {
  TaskData({Key key}) : super(key: key);
  @override
  TaskDataState createState() => TaskDataState();
}

class TaskDataState extends State<TaskData> {
  TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Task Info',
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
                    labelText: "Should be done by...",
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
                    labelText: "Enter Task Update...",
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
                leading: Text("Set As Completed"),
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
    );
  }
}
