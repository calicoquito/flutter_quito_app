import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addmembers.dart';
import 'helperclasses/imgmanager.dart';
import 'helperclasses/jsons.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'helperclasses/usersmanager.dart';
import 'userinfo.dart';

class EventsInfoEdit extends StatefulWidget {
  final String url;
  final User user;
  EventsInfoEdit({@required this.url, this.user});
  EventsInfoEditState createState() =>
      EventsInfoEditState(url: url, user: user);
}

class EventsInfoEditState extends State<EventsInfoEdit> {
  final String url;
  final User user;
  EventsInfoEditState({@required this.url, this.user});
  String textString = "";
  bool isSwitched = false;
  List setval = List();
  List<String> assignedMembers;
  List members = [];
  List displayMembers = List();

  File photo;
  Map data = Map();
  File croppedFile;
  bool uploaded;

  @override
  void initState() {
    super.initState();
    //print(url);
    getdata();
  }

  Map jsonstr = Jsons.projectsjson;

  Future<String> getdata() async {
    Map netdata = await NetManager.getProjectEditData(url);
    data = netdata["data"];
    var file = netdata["file"];
    //assignedMembers = netdata["assignedMembers"];
    setState(() {
      photo = data['image'] == null ? null : file;
    });
    //print('${data["members"]}');

    displayMembers = await UsersManager.getmatchingusers(data['members']);
    print(data["members"]);
    setState(() {
      displayMembers = displayMembers;
    });

    return "Success!";
  }

  Future<String> uploadPatch() async {
    var file = photo == null ? File('assets/images/default-image.jpg') : photo;
    String imgstring =
        croppedFile == null ? "" : base64Encode(croppedFile.readAsBytesSync());
    jsonstr["image"]["data"] = data["image"] != null
        ? base64Encode(file.readAsBytesSync())
        : imgstring;
    int respcode = await NetManager.editProject(url, jsonstr); // NEW
    if (respcode != 204) {
      //UploadQueue.addproject(url, jsonstr);
    }
    return "Success!";
  }

  Widget inputWidget(
      {icon: Icon, useswitch = "", txt: Text, drop: DropdownButton}) {
    String diplaytxt = txt.replaceAll(new RegExp(r'_'), ' ');
    diplaytxt = '${diplaytxt[0].toUpperCase()}${diplaytxt.substring(1)}';
    double width = MediaQuery.of(context).size.width;
    var padtext = Text(
      diplaytxt,
      style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
    );
    var text = TextField(
      autocorrect: true,
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        helperText: diplaytxt,
        hintText: data[txt].runtimeType == String ? data[txt] : "",
        contentPadding: EdgeInsets.all(14.0),
      ),
      onChanged: (string) {
        setState(() {
          //print(jsonstr[txt]);
          jsonstr[txt] = string;
        });
      },
    );
    var switchtrue = Switch(
        value: jsonstr[useswitch] == true ? true : false,
        onChanged: (value) {
          setState(() {
            jsonstr[useswitch] = value;
          });
        });
    return Container(
        padding: EdgeInsets.only(top: 4.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 4.0, right: 8.0),
                      child: icon),
                  useswitch == ""
                      ? Container(
                          width: width * .7,
                          child: text,
                        )
                      : Container(
                          width: width * .7,
                          child: padtext,
                        ),
                  useswitch == "" ? Text("") : switchtrue
                ],
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Edit Project',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
        Container(
          margin: EdgeInsets.all(0),
          color: Colors.black54,
          //padding: EdgeInsets.all(20.0),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            color: Colors.black54,
            child: photo == null
                ? Icon(
                    Icons.add_a_photo,
                    size: 80.0,
                    color: Colors.white,
                  )
                : Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            onPressed: () async {
              File newimg = await ImgManager.optionsDialogBox(context);
              if (newimg != null) {
                setState(() {
                  photo = newimg;
                });
              }
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
                    return AddMembersPage(user, datatype.project, url);
                  }));
                  displayMembers =
                      await UsersManager.getmatchingusers(assignedMembers);
                  if (assignedMembers != null) {
                    setState(() {
                      jsonstr["members"] = assignedMembers == null
                          ? null
                          : jsonstr["members"].addAll(assignedMembers);
                      displayMembers = displayMembers;
                    });
                  }
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
                              return UserInfo(userinfo: displayMembers[index]);
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
        inputWidget(icon: Icon(Icons.title), txt: jsonstr.keys.elementAt(1)),
        inputWidget(
            icon: Icon(Icons.import_contacts), txt: jsonstr.keys.elementAt(2)),
        inputWidget(
            icon: Icon(Icons.access_time),
            txt: jsonstr.keys.elementAt(6),
            useswitch: jsonstr.keys.elementAt(6)),
        inputWidget(
            icon: Icon(Icons.timer_off),
            txt: jsonstr.keys.elementAt(7),
            useswitch: jsonstr.keys.elementAt(7)),
        inputWidget(icon: Icon(Icons.contacts), txt: jsonstr.keys.elementAt(9)),
        inputWidget(icon: Icon(Icons.email), txt: jsonstr.keys.elementAt(10)),
        inputWidget(icon: Icon(Icons.phone), txt: jsonstr.keys.elementAt(11)),
        inputWidget(
            icon: Icon(Icons.add_location), txt: jsonstr.keys.elementAt(13)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadPatch();
          Navigator.pop(context, uploaded);
        },
        tooltip: 'Create Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
