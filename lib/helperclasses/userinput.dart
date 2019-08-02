import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  UserInputState createState() => UserInputState();
}

class UserInputState extends State<UserInput> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  Widget inputWidget(Map jsonstr,
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
        value: jsonstr[useswitch],
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
                  useswitch == "" ? Text("") : switch_true
                ],
              ),
            ],
          ),
        ));
  }
  }

}