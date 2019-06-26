import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'eventsinfo.dart';
import 'newproject.dart';
import 'tasks.dart';
import 'dart:async';


class EventList extends StatefulWidget {
  EventListState createState() => EventListState();
}

class EventListState extends State<EventList> {
  final String url = "http://192.168.100.67:8080/Plone/projects";
  List data;
  List<String> image_links = List();
  List event_names = List();

  @override
  void initState() {
    super.initState();
    getSWData();
  }


  Future<String> getSWData() async {
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    data = resBody["items"];

    Map jsonstr = { 
    "@type": "project",
      "allow_discussion": false,
      "attendees": [],
      "changeNote": "",
      "contact_email": "umain@gmail.com",
      "contact_name": "User main",
      "contact_phone": "18761234567",
      "contributors": [],
      "created": "2019-06-12T17:39:26+00:00",
      "creators": [
        "admin"
      ],
      "description": "Project for tessting purposes",
      "effective": "2019-06-12T12:53:08",
      "end": "2019-06-16T18:20:00+00:00",
      "event_url": null,
      "exclude_from_nav":false,
      "expires": null,
      "recurrence": null,
      "review_state": "published",
      "rights": null,
      "start": "2019-06-12T17:20:00+00:00",
      "subjects": [],
      "text": {
        "content-type": "text/html",
        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
        "encoding": "utf-8"
      },
      "title": "Test project5",
      "versioning_enabled": true,
      "whole_day": false
    };


    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var resp = await http.post(url, headers: 
    {"Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Basic $credentials"},
    body: jsonEncode(jsonstr));
      print(resp.body);

    Future<String> getimglinks(int i) async {
      try {
        var resp = await http
            .get(data[i]["@id"], headers: {
              "Accept": "application/json"});
        var respBody = json.decode(resp.body);
        if (respBody != null) {
          return respBody["image"]["scales"]["thumb"]["download"];
        }
      } catch (e) {}
    }

    gettitle(int i) {
      try {
        return data[i]["title"];
      } catch (e) {}
    }
    for (var i = 1; i <= data.length; i++) {
      var imgs = await getimglinks(i);
      if (imgs != null) {
        image_links.add(imgs);
      }
      if (i < data.length){
      event_names.add(data[i]["title"]);

      }
    }
    setState(() {
      image_links = image_links;
      event_names = event_names;
    });
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length-1,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskList(url: data[index]["@id"]);
                        }));
                      },
                      leading: CircleAvatar(
                        radius: 28.0,
                        backgroundImage: NetworkImage(image_links[index]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text("Event Name: ${event_names[index]} "),
                      subtitle: Text("Event type: ${data[index]["@type"]}",
                          style:
                              TextStyle(fontSize: 10.0, color: Colors.black54)),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Events',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(child: lst(Icon(Icons.person), data)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EventsInfo();
          }));
        },
      ),
    );
  }
}
