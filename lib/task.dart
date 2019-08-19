import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quito_1/helperclasses/usersmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'addmembers.dart';
import 'helperclasses/jsons.dart';

import 'userinfo.dart';

class Task extends StatefulWidget {
  final User user;
  final String projecturl;
  Task(this.user, this.projecturl);
  @override
  TaskState createState() => TaskState(user, projecturl);
}

class TaskState extends State<Task> {
  final User user;
  final String projecturl;
  TaskState(this.user, this.projecturl);
  //TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;
  List assignedMembers = [];
  List displayMembers = List();

  Map taskjson = Jsons.taskjson;

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
                      return AddMembersPage(user, datatype.task, projecturl);
                    }));
                    print(assignedMembers);
                    displayMembers =
                        await UsersManager.getmatchingusers(assignedMembers);
                    setState(() {
                      displayMembers = displayMembers;
                      taskjson["members"] = [assignedMembers.join(',')];
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
          NetManager.uploadTask(projecturl, taskjson);
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      ),
    );
  }
}
