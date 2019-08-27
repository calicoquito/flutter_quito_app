import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'addmembers.dart';
import 'helperclasses/imgmanager.dart';
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
  bool isSwitched = false;
  List<String> assignedMembers;
  List members = [];
  List displayMembers = List();

  File photo;
  Map data = Map();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<String> getdata() async {
    Map netdata = await NetManager.getProjectEditData(url);
    data = netdata["data"];
    var file = netdata["file"];
    if (this.mounted) {
      setState(() {
        photo = data['image'] == null ? null : file;
      });
    }
    displayMembers = await UsersManager.getmatchingusers(data['members']);
    if (this.mounted) {
      setState(() {
        displayMembers = displayMembers;
      });
    }

    return "Success!";
  }

  Future<String> uploadPatch() async {
    data["image"] = photo == null
        ? {
            "filename": "test.jpg",
            "content-type": "image/jpeg",
            "data": "",
            "encoding": "base64"
          }
        : {
            "filename": "test.jpg",
            "content-type": "image/jpeg",
            "data": base64Encode(photo.readAsBytesSync()),
            "encoding": "base64"
          };
    NetManager.editProject(url, data);

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
        if (this.mounted) {
          setState(() {
            data[txt] = string;
          });
        }
      },
    );
    var switchtrue = Switch(
        value: data[useswitch] == true ? true : false,
        onChanged: (value) {
          if (this.mounted) {
            setState(() {
              data[useswitch] = value;
            });
          }
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Edit Project',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: ListView(padding: EdgeInsets.all(0), children: <Widget>[
        Container(
          margin: EdgeInsets.all(0),
          color: Colors.black54,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            color: Colors.black54,
            child: photo == null
                ? Container(
                    height: height * 0.4,
                    margin: EdgeInsets.all(0),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 80.0,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    height: height * 0.4,
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
                if (this.mounted) {
                  setState(() {
                    photo = newimg;
                  });
                }
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
                    if (this.mounted) {
                      setState(() {
                        data["members"].addAll(assignedMembers.where(
                            (member) => !data["members"].contains(member)));
                        displayMembers = displayMembers;
                      });
                    }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    data["start"] = date.toString();
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text('    Start', style: TextStyle(color: Colors.white))
                  ],
                )),
            SizedBox(
              width: 10,
            ),
            RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    data["end"] = date.toString();
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text('    End', style: TextStyle(color: Colors.white))
                  ],
                )),
          ],
        ),
        inputWidget(icon: Icon(Icons.title), txt: "title"),
        inputWidget(icon: Icon(Icons.import_contacts), txt: "description"),
        inputWidget(
            icon: Icon(Icons.access_time),
            txt: "open_end",
            useswitch: "open_end"),
        inputWidget(
            icon: Icon(Icons.timer_off),
            txt: "open_end",
            useswitch: "open_end"),
        inputWidget(icon: Icon(Icons.contacts), txt: "contact_name"),
        inputWidget(icon: Icon(Icons.email), txt: "contact_email"),
        inputWidget(icon: Icon(Icons.phone), txt: "contact_phone"),
        inputWidget(icon: Icon(Icons.add_location), txt: "location"),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadPatch();
          Navigator.pop(
            context,
          );
        },
        tooltip: 'Edit Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
