import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quito_1/helperclasses/usersmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'addmembers.dart';

import 'userinfo.dart';

class Taskedit extends StatefulWidget {
  final User user;
  final String taskurl;
  final String projecturl;
  Taskedit( this.taskurl, this.user, this.projecturl);
  @override
  TaskeditState createState() => TaskeditState(taskurl, user, projecturl);
}

class TaskeditState extends State<Taskedit> {
  final User user;
  String taskurl;
  final String projecturl;
  TaskeditState(this.taskurl, this.user, this.projecturl);
  String textString = "";
  bool isSwitched = false;
  List setval;
  List assignedMembers = [];
  List displayMembers = List();
  Map data = Map();
  String title;
  String description;
  String details;

  //Map taskjson = Jsons.taskjson;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    data = await NetManager.getTask(taskurl);
    if (data["members"] != null) {
      assignedMembers = data["members"].isEmpty ? null : data["members"];
    }
    title = data["title"] == null ? "" : "${data["title"]}";
    description = data["description"] == null
        ? ""
        : " ${data["description"]}";
    details = data["task_detail"]["data"] == null
        ? ""
        : "${data["task_detail"]["data"]}";
    details = details.replaceAll(new RegExp(r'<h2>'), ' ');
    details = details.replaceAll(new RegExp(r'</h2>'), ' ');
    displayMembers = await UsersManager.getmatchingusers(data["members"]);

    setState(() {
      assignedMembers = assignedMembers;
      title = title;
      description = description;
      details = details;
      displayMembers = displayMembers;
    });
    return "Success!";
  }

  editTask() {
    NetManager.editTask(taskurl, data);
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
                  data["title"] = string;
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
                  hintText: details == null ? "" : description,
                  //labelText: "Description...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  data["description"]["data"] = "<h2>$string<h2>";
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
                  hintText: details == null ? "" : details,
                  //labelText: "Task Details...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  data["detail"] = string;
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
                      return AddMembersPage(user, datatype.task, projecturl);
                    }));
                    print(assignedMembers);
                    displayMembers =
                        await UsersManager.getmatchingusers(assignedMembers);
                    setState(() {
                      displayMembers = displayMembers;
                      data["members"] = assignedMembers == null ? null : [assignedMembers.join(',')];
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
