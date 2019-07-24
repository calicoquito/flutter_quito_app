import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'addmembers.dart';
import 'user.dart';

class Task extends StatefulWidget {
  String url;
  Task({@required this.url});
  @override
  TaskState createState() => TaskState(url: url);
}

class TaskState extends State<Task> {
  String url;
  TaskState({@required this.url});
  //TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;
  List assignedMembers;

  Map taskjson = {
    "@type": "task",
    "title": "Task upload by api",
    "description": "the task is to test the api",
    "task_detail": {
      "content-type": "text/html",
      "data": "<h2>Talk to some people to volunteer on the the project</h2>",
      "encoding": "utf-8"
    },
    "additional_files": null,
    "complete": false
  };

  Future<String> uploadTask() async {
    print(url);
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var resp = await http.post(url + "/need-to-do",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Basic $credentials"
        },
        body: jsonEncode(taskjson));
    print(resp.statusCode);
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    final List<int> items = [1, 2, 3, 4, 5, 6];
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

              ///controller: controller,
              decoration: InputDecoration(
                  labelText: "Title...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  taskjson["title"] = string;
                });
              },
              onEditingComplete: () {
                //controller.clear();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: TextField(
              autocorrect: true,
              //controller: controller,
              decoration: InputDecoration(
                  labelText: "Description...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  taskjson["description"]["data"] = "<h2>$string<h2>";
                });
              },
              onEditingComplete: () {
                //controller.clear();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: TextField(
              maxLines: 4,
              autocorrect: true,
              //controller: controller,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                  labelText: "Task Details...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  taskjson["task_detail"] = string;
                });
              },
              onEditingComplete: () {
                //controller.clear();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
            child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: () async {
                    setState(() async {
                      assignedMembers = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddMembersPage();
                      }));
                    });

                    print(assignedMembers);
                  },
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                )),
          ),
          // Container(
          //     padding: EdgeInsets.symmetric(vertical: 30.0),
          //     child: Text(
          //       assignedMembers == null
          //           ? "No one assigned yet"
          //           : '${assignedMembers.length} person(s) added to this task',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.black54),
          //     )),
          Container(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: assignedMembers == null ? 0 : assignedMembers.length,
              itemBuilder: (context, index) {
                  return Container(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              FlatButton(child: 
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                    assignedMembers[index]["portrait"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: ()=> Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return User(user: assignedMembers[index]);
                      })),
                              ),
                              Text(
                                "${assignedMembers[index]["fullname"]}",
                                textAlign: TextAlign.center,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ],
                          )));

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        onPressed: () {
          uploadTask();
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      ),
    );
  }
}
