import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addmembers.dart';
import 'helperclasses/user.dart';
import 'userinfo.dart';

class EventsInfoEdit extends StatefulWidget {
  final String url;
  final User user;
  EventsInfoEdit({@required this.url, this.user});
  EventsInfoEditState createState() => EventsInfoEditState(url: url, user: user);
}

class EventsInfoEditState extends State<EventsInfoEdit> {
  final String url;
  final User user;
  EventsInfoEditState({@required this.url, this.user});
  //TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval = List();
  List assignedMembers;
  List members = [];

  File photo;
  Map data = Map();
  File croppedFile;
  bool uploaded;

  @override
  void initState() {
    super.initState();
    print(url);
    getdata();
  }

  Map jsonstr = {
    "@type": "project",
    "title": "Project by api 4",
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
            content: new SingleChildScrollView(
              child: new ListBody(
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

  Future<String> getdata() async {
    var resp = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.user.ploneToken}",
    });
    print(resp.statusCode);
    data = json.decode(resp.body);
    if (data["contributors"] != null){
    assignedMembers = data["contributors"].isEmpty ? null 
    : json.decode(data["contributors"][0]);}
    var file = await DefaultCacheManager().getSingleFile(data['image']['download']);
    setState(() {
      photo = data['image'] == null? null
          : file;
    });

    return "Success!";
  }

  Future openimg(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    if (file != null){
      cropImage(file);
      file = photo;
    }
      var base64Image = file != null ? base64Encode(file.readAsBytesSync()) : "";
      jsonstr["image"]["data"] = base64Image;
    
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

  Future<String> uploadPatch() async {
    var file = photo == null ? File('assets/images/default-image.jpg'): photo;
    String imgstring = croppedFile == null ? "" 
    : base64Encode(croppedFile.readAsBytesSync());
    jsonstr["image"]["data"] = data["image"] != null
        ? base64Encode(file.readAsBytesSync()) : imgstring;
    var resp = await http.patch(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.user.ploneToken}",
        },
        body: jsonEncode(jsonstr));
    print(resp.statusCode);
    if (resp.statusCode == 204){uploaded = true;} 
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
        hintText: data[txt].runtimeType == String? data[txt] : "",
        contentPadding: EdgeInsets.all(14.0),
      ),
      onChanged: (string) {
        setState(() {
          print(jsonstr[txt]);
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
      body: ListView(children: <Widget>[
        Container(
          color: Colors.black54,
          //padding: EdgeInsets.all(20.0),
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

                    print(jsonstr["contributors"]);
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
                              backgroundImage:  assignedMembers[index]["portrait"] == null ? 
                                AssetImage('assets/images/default-image.jpg') :
                                NetworkImage(assignedMembers[index]["portrait"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserInfo(userinfo: assignedMembers[index]);
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
