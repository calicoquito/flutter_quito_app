import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class TaskData extends StatefulWidget {
  final String url;
  TaskData({@required this.url});
  TaskDataState createState() => TaskDataState(url: url);
}

class TaskDataState extends State<TaskData> {
  final String url;
  TaskDataState({@required this.url});
  Map data;
  String textString = "";
  bool isSwitched = false;
  String description;
  String title;
  String details;


  @override
  void initState() {
    super.initState();
    getSWData();
  }

  Future<String> getSWData() async {
    var response = await http.get(url + "/need-to-do", headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    print(resBody);
    setState(() {
      data = resBody;
      title = data["title"] == null ? "Tile: " : "Title: ${data["title"]}";
      description = data["description"] == null ? "Description: " : "Description: ${data["description"]}";
      //details = data["task_detail"]["data"] == null ? "Details: " : "Details: ${data["task_detail"]["data"]}";
      print(url);
      print('${data["title"]}, ${data["description"]}, ${data["task_detail"]}');
    });
    return "Success!";
  }



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
              child: Text(
                title == null ? "" : title    
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                description == null ? "" : description 
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                "Details:"//details
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
                        //taskjson["complete"] = true;
                      });
                    }),
              ),
            ),
          ],
        ),
    );
  }
}
