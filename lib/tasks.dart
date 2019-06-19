import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task.dart';
import 'taskdata.dart';
import 'dart:math';

class TaskList extends StatefulWidget {
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  final String url =
      "http://192.168.100.69:8080/Plone/projects/copy4_of_concert/need-to-do";
  List data = List();
  List<bool> setval = List();

  @override
  void initState() {
    super.initState();
    getSWData();
  }

  Future<String> getSWData() async {
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);

    setState(() {
      data = resBody["items"];
      for (var i in data) {
        setval.add(false);
      }
    });
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
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
                        contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TaskData();
                          }));
                        },
                        leading: CircleAvatar(
                          child: Text("${data[index]["title"].split('')[0]}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          radius: 48.0,
                          backgroundColor:
                              Colors.primaries[Random().nextInt(15)],
                        ),
                        title: Text("Task Name: ${data[index]["title"]}"),
                        subtitle: Text("Task Data: To do ${data[index]} ",
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.black54)),
                        trailing: Checkbox(
                            value: setval[index],
                            onChanged: (bool value) {
                              setState(() {
                                setval[index] = value;
                              });
                            })),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Tasks',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(child: lst(Icon(Icons.person), data)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Task();
          }));
        },
      ),
    );
  }
}
