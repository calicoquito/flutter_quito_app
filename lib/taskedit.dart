import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quito_1/helperclasses/usersmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'dart:convert';
import 'addmembers.dart';
import 'helperclasses/jsons.dart';
import 'package:http/http.dart' as http;

import 'userinfo.dart';

class Taskedit extends StatefulWidget {
  final User user;
  String url;
  Taskedit({@required this.url, this.user});
  @override
  TaskeditState createState() => TaskeditState(url: url, user: user);
}

class TaskeditState extends State<Taskedit> {
  final User user;
  String url;
  TaskeditState({@required this.url, this.user});
  String textString = "";
  bool isSwitched = false;
  List setval;
  List assignedMembers = [];
  List displayMembers = List();
  Map data = Map();
  String title;
  String description;

  Map taskjson = Jsons.taskjson;

  Future<String> getSWData() async {
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.user.ploneToken}",
    });
    var resBody = json.decode(response.body);
    setState(() {
      data = resBody;
      if (data["members"] != null) {
        assignedMembers = data["members"].isEmpty ? null : data["members"];
      }
      title = data["title"] == null ? "Tile: " : "Title: ${data["title"]}";
      description = data["description"] == null
          ? "Description: "
          : "Description: ${data["description"]}";
      //details = data["detail"]["data"] == null ? "Details: " : "Details: ${data["detail"]["data"]}";
      print(data["members"]);
      print('${data["title"]}, ${data["description"]}, ${data["detail"]}');
    });
    return "Success!";
  }

  editTask() {
    NetManager.uploadTask(url, taskjson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Task Edit',
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
                  helperText: "Title...",
                  hintText: title == null ? "" : title,
                  //labelText: "Title...",
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
                  helperText: "Description...",
                  hintText: description == null ? "" : description,
                  //labelText: "Description...",
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
                  helperText: "Task Details...",
                  hintText: description == null ? "" : description,
                  //labelText: "Task Details...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  taskjson["detail"] = string;
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
                    assignedMembers = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddMembersPage(user: user);
                    }));
                    print(assignedMembers);
                    displayMembers =
                        await UsersManager.getmatchingusers(assignedMembers);
                    setState(() {
                      displayMembers = displayMembers;
                      taskjson["members"] = json.encode(assignedMembers);
                    });
                  },
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                )),
          ),
          Container(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayMembers == null ? 0 : displayMembers.length,
              itemBuilder: (context, index) {
                return Container(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            FlatButton(
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    displayMembers[index]["portrait"] == null
                                        ? AssetImage(
                                            'assets/images/default-image.jpg')
                                        : NetworkImage(
                                            displayMembers[index]["portrait"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UserInfo(
                                        userinfo: displayMembers[index]);
                                  })),
                            ),
                            Text(
                              "${displayMembers[index]["fullname"]}",
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
          editTask();
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      ),
    );
  }
}
