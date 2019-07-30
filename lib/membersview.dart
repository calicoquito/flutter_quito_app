import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    // var bytes = utf8.encode("admin:admin");
    // var credentials = base64.encode(bytes);
    var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${widget.user.ploneToken}",
    });

    setState(() {
      var resBody = json.decode(response.body);
      List members = resBody["attendees"] == null ? null : json.decode(resBody["attendees"]);

      if (members != null && members != []){
        data = members;
      }else{data = [];}
    });
    return "Success!";
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
                      contentPadding: EdgeInsets.only(top: 4.0,left: 4.0),
                      onTap: ()=> Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserInfo(userinfo: data[index]);
                      })),
                      leading: CircleAvatar(
                        radius:20.0,
                        backgroundImage: data[index]["portrait"] == null ? 
                        AssetImage('assets/images/default-image.jpg') : 
                        NetworkImage(data[index]["portrait"]),
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
    return Scaffold(
           appBar: AppBar(
          title: Text(
        'Assigned Members',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(child: inputWidget(data)),

    );
  }
}
