import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quito_1/userinfo.dart';

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
    title = data["title"] == null ? "Tile: " : "Title: ${data["title"]}";
    description = data["description"] == null
        ? "Description: "
        : "Description: ${data["description"]}";
    details = data["task_detail"]["data"] == null
        ? "Details: "
        : "Details: ${data["task_detail"]["data"]}";
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
            child: Text(title == null ? "" : title),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(description == null ? "" : description),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(details == null ? "" : details),
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
                      data["complete"] = value;
                    });
                  }),
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
    );
  }
}
