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

  Widget lst({icon: Icon, swit: bool, txt: Text, drop: DropdownButton}) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          var text = txt == null
              ? Container(
                  child: TextField(
                    maxLines: 4,
                    autocorrect: true,
                    controller: controller,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        labelText: fields[index],
                        contentPadding: EdgeInsets.all(14.0),
                        border: OutlineInputBorder()),
                    onChanged: (string) {
                      setState(() {
                        textString = string;
                      });
                    },
                    onEditingComplete: () {
                      controller.clear();
                    },
                  ),
                )
              : null;
          var swi = Switch(
              value: swit,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              });
          return Container(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: icon),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        decoration:
                            const InputDecoration(helperText: "Enter App ID"),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: icon),
                  ],
                ),
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Assign Task',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(
          child: lst(icon: Icon(Icons.person), txt: fields[1], swit: true)),
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

