import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/tasks.dart';
import 'people.dart';

class EventsInfo extends StatefulWidget {
  // EventsInfo({Key key}) : super(key: key);
  // @override
  EventsInfoState createState() => EventsInfoState();
}

class EventsInfoState extends State<EventsInfo> {
  TextEditingController controller = TextEditingController();
  String textString = "";
  bool isSwitched = false;
  List setval;
  final List fields = [
    "allow_discussion",
    "attendees",
    "changeNote",
    "contact_email",
    "contact_name",
    "contact_phone",
    "contributors",
    "created",
    "creators",
    "description",
    "effective",
    "end",
    "event_url",
    "exclude_from_nav",
    "expires",
    "recurrence",
    "review_state",
    "rights",
    "start",
    "subjects",
    "text",
    "title",
    "versioning_enabled",
    "whole_day"
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   getSWData();
  // }

  // void getSWData(){
  //   setState(() {
  //     for (var i in data) {
  //       setval.add(false);
  //     }
  //   });
  //   }

  Widget inputWidget({icon: Icon, swit: bool, txt: Text, drop: DropdownButton}) {
          double width = MediaQuery.of(context).size.width;
          var padtext =  Text(txt,
          style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
          );
          var text =  TextField(
                    autocorrect: true,
                    controller: controller,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        labelText: txt,
                        contentPadding: EdgeInsets.all(14.0),),
                    onChanged: (string) {
                      setState(() {
                        textString = string;
                      });
                    },
                    onEditingComplete: () {
                      controller.clear();
                    },
                  );
          var switch_true = Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
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
                      padding: EdgeInsets.only(left:4.0, right: 8.0),
                      child: icon),
                    swit == false ?Container(
                      width: width*.7,
                      child: text,
                    ): Container(
                      width: width*.7,
                      child:padtext,
                    ),
                    swit != false ?  switch_true: Text("")
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
        'Add Project',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Column(
          children: <Widget>[
            inputWidget(icon: Icon(Icons.person), txt: fields[1], swit: true),
            inputWidget(icon: Icon(Icons.add_a_photo), txt: fields[2], swit: false),
          ]
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TaskList();
          }));
        },
        tooltip: 'Create task',
        child: Icon(Icons.check),
      ),
    );
  }
}

