import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quito_1/userinfo.dart';

import 'helperclasses/dialogmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'helperclasses/usersmanager.dart';

class TaskData extends StatefulWidget {
  final String url;
  final User user;
  TaskData({@required this.url, this.user});
  TaskDataState createState() => TaskDataState(url: url, user: user);
}

class TaskDataState extends State<TaskData> {
  final String url;
  final User user;
  TaskDataState({@required this.url, this.user});
  Map data;
  String textString = "";
  bool isSwitched = false;
  String description;
  String title;
  String details;
  List assignedMembers = List();
  List displayMembers = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    data = await NetManager.getTask(url);
    if (data["members"] != null) {
      assignedMembers = data["members"].isEmpty ? null : data["members"];
    }
    title = data["title"] == null ? "" : "${data["title"]}";
    description = data["description"] == null ? "" : data["description"];
    details = data["task_detail"]["data"] == null
        ? ""
        : "${data["task_detail"]["data"]}";
    details = details.replaceAll(new RegExp(r'<h2>'), ' ');
    details = details.replaceAll(new RegExp(r'</h2>'), ' ');
    displayMembers = await UsersManager.getmatchingusers(data["members"]);
    if (this.mounted) {
      setState(() {
        assignedMembers = assignedMembers;
        title = title;
        description = description;
        details = details;
        displayMembers = displayMembers;
        isSwitched = data["complete"];
      });
    }
    return "Success!";
  }

  editTask() {
    NetManager.editTask(url, data);
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
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Title:",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      Text(title == null ? "" : title),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Details:",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      Text(details == null ? "" : details),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Description:",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      Text(description == null ? "" : description),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              leading: Text("Set As Completed"),
              trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) async {
                    if (value) {
                      await DialogManager.complete(context,
                          "Are You Sure You Want mark this task as complete?");
                      if (DialogManager.answer == true) {
                        setState(() {
                          isSwitched = value;
                          data["complete"] = value;
                        });
                        editTask();
                      }
                    } else {
                      await DialogManager.complete(context,
                          "Are You Sure You Want mark this task as Incomplete?");
                      if (DialogManager.answer == true) {
                        setState(() {
                          isSwitched = value;
                          data["complete"] = value;
                        });
                        editTask();
                      }
                    }
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Team:",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayMembers == null ? 0 : displayMembers.length,
              itemBuilder: (context, index) {
                return Container(
                    child: Padding(
                        padding: EdgeInsets.all(5),
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
    );
  }
}
