import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quito_1/helperclasses/jsons.dart';

import 'addmembers.dart';
import 'helperclasses/imgmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/uploadqueue.dart';
import 'helperclasses/urls.dart';
import 'helperclasses/user.dart';
import 'userinfo.dart';

class EventsInfo extends StatefulWidget {
  final String url;
  final User user;
  EventsInfo({this.url, this.user});
  EventsInfoState createState() => EventsInfoState(user: user);
}

class EventsInfoState extends State<EventsInfo> {
  final String url = Urls.main;
  final User user;
  EventsInfoState({this.user});
  String textString = "";
  bool isSwitched = false;
  List setval;
  var photo;
  File croppedFile;
  bool uploaded;
  List assignedMembers = [];
  Map jsonstr = Jsons.projectsjson;

  Future<String> uploadImg() async {
    var base64Image =
        photo != null ? base64Encode(photo.readAsBytesSync()) : "";
    jsonstr["image"]["data"] = base64Image;
    int respcode = await NetManager.uploadProject(url, jsonstr);  // NEW
    if (respcode != 204){
      UploadQueue.addproject(url, jsonstr);
    }
    return "Success!";
  }


  Widget inputWidget(
      {icon: Icon, useswitch = "", txt: Text, drop: DropdownButton}) {
    String diplaytxt = txt.replaceAll(RegExp(r'_'), ' ');
    diplaytxt = '${diplaytxt[0].toUpperCase()}${diplaytxt.substring(1)}';
    double width = MediaQuery.of(context).size.width;
    var padtext = Text(
      diplaytxt,
      style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
    );
    var text = TextField(
      autocorrect: true,
      //controller: controller,
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        labelText: diplaytxt,
        contentPadding: EdgeInsets.all(14.0),
      ),
      onChanged: (string) {
        setState(() {
          jsonstr[txt] = string;
          print(jsonstr);
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
    final User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Project',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: ListView(children: <Widget>[
        Container(
          color: Colors.transparent,
          child: FlatButton(
            padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
            color: Colors.black54,
            child: photo == null
                ? Icon(
                    Icons.add_a_photo,
                    size: 80.0,
                    color: Colors.white,
                  )
                : Image.file(photo),
            onPressed: ()async{
              File newimg = await ImgManager.optionsDialogBox(context);
              setState((){
                photo = newimg;
              });
              
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

                  setState(() {
                    assignedMembers =
                        assignedMembers == null ? [] : assignedMembers;
                    jsonstr["contributors"] = json.encode(assignedMembers);

                    for (var i in assignedMembers) {
                      jsonstr["members"].add(json.encode(i));
                    }
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
            itemCount: assignedMembers == null ? 0 : assignedMembers.length,
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
                                  assignedMembers[index]["portrait"] == null
                                      ? AssetImage(
                                          'assets/images/default-image.jpg')
                                      : NetworkImage(
                                          assignedMembers[index]["portrait"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserInfo(
                                      userinfo: assignedMembers[index]);
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
        onPressed: () async {
          uploadImg();

          // Javier
          // I am adding this block of code to facilitate
          // create of channel for when a project is created
          try {
            final resp = await http.post(
                'http://mattermost.alteroo.com/api/v4/channels',
                headers: {'Authorization': 'Bearer ${user.mattermostToken}'},
                body: jsonEncode({
                  "team_id": "fqi8t55eatr6tytz1yxosntfhe",
                  "type": "O",
                  "display_name": jsonstr['title'],
                  "name": jsonstr['title'],
                  "header": "",
                  "purpose": jsonstr['description'],
                  "creator_id": "${user.userId}",
                }));
            if (resp.statusCode == 200) {
              final jsonData = jsonDecode(resp.body);
              await http.post(
                  'http://mattermost.alteroo.com/api/v4/channels/${jsonData['id']}/members',
                  headers: {'Authorization': 'Bearer ${user.mattermostToken}'},
                  body: jsonEncode({
                    "user_id": "p57uijbcu7rk8c391ycwcrifao",
                    "channel_id": "${jsonData['id']}",
                  }));
            }
            print('created');
          } catch (err) {
            print(err);
          }
          Navigator.pop(context, uploaded);
        },
        tooltip: 'Create Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
