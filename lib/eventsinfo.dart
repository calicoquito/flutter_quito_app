import 'dart:convert';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventsInfo extends StatefulWidget {
  // EventsInfo({Key key}) : super(key: key);
  // @override
  EventsInfoState createState() => EventsInfoState();
}

class EventsInfoState extends State<EventsInfo> {
  final String url = "http://192.168.100.67:8080/Plone/projects";
  TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;

  Map jsonstr = {
    "@type": "project",
    "title": "Project by api 2",
    "description": "Project for tessting purposes",
    "attendees": [],
    "start": "2019-06-12T17:20:00+00:00",
    "end": "2020-06-17T19:00:00+00:00",
    "whole_day": true,
    "open_end": true,
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

  Future<String> setProjectData() async {
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var resp = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Basic $credentials"
        },
        body: jsonEncode(jsonstr));
    print(resp.body);
    return "Success!";
  }

  Future uploadImg(String fileName) async {
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    String uri = 'http://192.168.100.67:8080/Plone/projects';
    String base64Image = base64Encode(file.readAsBytesSync());
    jsonstr["image"]["data"] = base64Image;
    var resp = await http.post(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Basic $credentials"
    }, body: {
      jsonEncode(jsonstr)
    });
    print(resp.body);
    print("Nope");
    return "Success!";
  }

  Widget inputWidget(
      {icon: Icon, use_switch = "", txt: Text, drop: DropdownButton}) {
    double width = MediaQuery.of(context).size.width;
    var padtext = Text(
      txt,
      style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
    );
    var text = TextField(
      autocorrect: true,
      controller: controller,
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        labelText: txt,
        contentPadding: EdgeInsets.all(14.0),
      ),
      onSubmitted: (string) {
        setState(() {
          jsonstr[txt] = string;
        });
      },
      onEditingComplete: () {
        controller.clear();
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
    print(jsonstr[jsonstr.keys.elementAt(1)]);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Project',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: ListView(children: <Widget>[
        inputWidget(
            icon: Icon(Icons.person),
            txt: jsonstr.keys.elementAt(1),
            use_switch: jsonstr.keys.elementAt(6)),
        inputWidget(
            icon: Icon(Icons.add_a_photo), txt: jsonstr.keys.elementAt(1)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImg("lake.jpg");
        },
        tooltip: 'Create Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
