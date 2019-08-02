import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addmembers.dart';
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
  EventsInfoState({ this.user});
  String textString = "";
  bool isSwitched = false;
  List setval;
  var photo;
  File croppedFile;

  List assignedMembers = [];

  Map jsonstr = {
    "@type": "project",
    "title": "Project by api 9",
    "description": "Project for tessting purposes",
    "contributors": [],
    "start": "2019-06-12T17:20:00+00:00",
    "end": "2020-06-17T19:00:00+00:00",
    "whole_day": false,
    "open_end": false,
    "sync_uid": null,
    "contact_name": "",
    "contact_email": "",
    "contact_phone": "",
    "event_url": null,
    "location": "Office Quito",
    "recurrence": null,
    "image": {
      "filename": "test.jpg",
      "content-type": "image/jpeg",
      "data": "",
      "encoding": "base64"
    },
    "image_caption": "Image captions",
    "text": {
      "content-type": "text/html",
      "data":
          "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
      "encoding": "utf-8"
    },
    "changeNote": null
  };

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Take a photo'),
                        Icon(Icons.camera)
                      ],
                    ),
                    onTap: () {
                      openimg(ImageSource.camera);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Select from gallery'),
                        Icon(Icons.image)
                      ],
                    ),
                    onTap: () {
                      openimg(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openimg(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      cropImage(file);
    }
  }

  Future<String> uploadImg() async {
    var base64Image = photo != null ? base64Encode(photo.readAsBytesSync()) : "";
    jsonstr["image"]["data"] = base64Image;
    var resp = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.user.ploneToken}",
        },
        body: jsonEncode(jsonstr));
    print(resp.statusCode);
    print(resp.body);
    return "Success!";
  }


  Future cropImage(File imageFile) async {
    croppedFile = await ImageCropper.cropImage(
      toolbarColor: Color(0xff7e1946),
      statusBarColor: Colors.blueGrey,
      toolbarWidgetColor: Colors.white,
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    setState(() {
      photo = croppedFile;
    });
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  
  Widget inputWidget(
      {icon: Icon, use_switch = "", txt: Text, drop: DropdownButton}) {
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
      onSubmitted: (string) {
        setState(() {
          
          jsonstr[txt] = string;
          print(jsonstr);
        });
      },
      onEditingComplete: () {
        //controller.clear();
      },
    );
    var switch_true = Switch(
        value: jsonstr[use_switch],
        onChanged: (value) {
          setState(() {
            jsonstr[use_switch] = value;
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
                  use_switch == ""
                      ? Container(
                          width: width * .7,
                          child: text,
                        )
                      : Container(
                          width: width * .7,
                          child: padtext,
                        ),
                  use_switch == "" ? Text("") : switch_true
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
            onPressed: () {
              _optionsDialogBox();
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
                    jsonstr["contributors"] = json.encode(assignedMembers);
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
            use_switch: jsonstr.keys.elementAt(6)),
        inputWidget(
            icon: Icon(Icons.timer_off),
            txt: jsonstr.keys.elementAt(7),
            use_switch: jsonstr.keys.elementAt(7)),
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
          Navigator.of(context, rootNavigator: true).pop(context);
        },
        tooltip: 'Create Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
