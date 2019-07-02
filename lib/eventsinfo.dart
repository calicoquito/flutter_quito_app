import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
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

  var jsonstr = {
    "@type": "project",
    "allow_discussion": false,
    "attendees": [],
    "changeNote": "",
    "contact_email": "umain@gmail.com",
    "contact_name": "User main",
    "contact_phone": "18761234567",
    "contributors": [],
    "created": "2019-06-12T17:39:26+00:00",
    "creators": ["admin"],
    "description": "Project for tessting purposes",
    "effective": "2019-06-12T12:53:08",
    "end": "2019-06-16T18:20:00+00:00",
    "event_url": null,
    "exclude_from_nav": false,
    "expires": null,
    "recurrence": null,
    "review_state": "published",
    "rights": null,
    "start": "2019-06-12T17:20:00+00:00",
    "subjects": [],
    "text": {
      "content-type": "text/html",
      "data":
          "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
      "encoding": "utf-8"
    },
    "title": "Test project5",
    "versioning_enabled": true,
    "whole_day": false,
    "image": null,
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

  //  Future uploadImg(String fileName) async {
  //    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
  //    String uri = 'http://localhost:8080/Plone/projects/test-project5/@@images/';
  //    //var file= File('assets/images/lake.jpg');
  //    //var file =Image(image: image, width: 20, height: 10);
  //    //var isExist = await file.exists();
  //    //if (isExist) {
  //    String base64Image = base64Encode(file.readAsBytesSync());
  //    //jsonstr["image"] = file;
  
  //    var resp = await http.post(uri, body: {
  //      'image': base64Image,
  //      //"name": fileName,
  //    });
  //    print(resp.body);
  //    //}
  //    //else
  //    print("Nope");
  //    return "Success!";
  //  }


upload() async {   
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery); 
      // open a bytestream
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse('http://192.168.100.67:8080/Plone/projects/test-project5/@@images/');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: path.basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFile);

      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
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
            use_switch: jsonstr.keys.elementAt(1)),
        inputWidget(
            icon: Icon(Icons.add_a_photo), txt: jsonstr.keys.elementAt(4)),
        DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/lake.jpg'),
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          upload();
          //setProjectData();
        },
        tooltip: 'Create Project',
        child: Icon(Icons.check),
      ),
    );
  }
}
