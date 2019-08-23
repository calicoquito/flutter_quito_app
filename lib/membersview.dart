import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/usersmanager.dart';
import 'helperclasses/user.dart';
import 'userinfo.dart';

class Members extends StatefulWidget {
  final User user;
  final String url;
  Members({@required this.url, this.user});
  MembersState createState() => MembersState(url: url, user: user);
}

class MembersState extends State<Members> {
  final User user;
  final String url;
  MembersState({@required this.url, this.user});
  List data = List();
  List newdata = List();
  List completelist = [0,0];
  @override
  void initState() {
    super.initState();
    getData();
    gettasksdata(url);
  }

  Future<String> getData() async {
    // var bytes = utf8.encode("admin:admin");
    // var credentials = base64.encode(bytes);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.user.ploneToken}",
    });
    var resBody = json.decode(response.body);
    print(resBody);
    var members = resBody["members"].isEmpty ? [] : resBody["members"];
    print(resBody);
    data = await UsersManager.getmatchingusers(members);
    setState(() {
      if (members != null && members != []) {
        data = data;
      } else {
        data = [];
      }
    });
    return "Success!";
  }

  gettasksdata(String url) async {
    int complete = 0;
    var list = await NetManager.getTasksData(url);
    for (var task in list) {
      Map taskinfo = await NetManager.getTask(task['@id']);
      if (taskinfo["complete"] == true) {
        complete += 1;
      }
    }
    completelist[0] = [complete, list.length];
  }


  Widget inputWidget(List data) {
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                    onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserInfo(userinfo: data[index]);
                        })),
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: data[index]["portrait"] == null
                          ? AssetImage('assets/images/default-image.jpg')
                          : NetworkImage(data[index]["portrait"]),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text("${data[index]["fullname"]}"),
                    subtitle: Text("Email: ${data[index]["email"]}",
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var percent = Random().nextInt(10);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Project Details',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            height: height*0.25,
            child: CircularPercentIndicator(
                radius: height*0.2,
                lineWidth: 5.0,
                animation:true,
                percent: percent * .1,
                center: new Text("${percent*10}%"),
                progressColor: Color(0xff7e1946)),
          ),
          Container(
            height: height*0.6,
            child: inputWidget(data),
          )
        ],
      )
          //child: inputWidget(data)

          ),
    );
  }
}
