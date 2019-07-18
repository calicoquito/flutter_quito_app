import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Members extends StatefulWidget {
  final String url;
  Members({@required this.url});
  MembersState createState() => MembersState(url: url);
} 

class MembersState extends State<Members> {
  final String url;
  MembersState({@required this.url});
  List data = List();
  List select_users = List();
  List select_gorups;
  List newdata = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    });

    setState(() {
      var resBody = json.decode(response.body);
      data = resBody["attendees"];
    });

    return "Success!";
  }


    Widget lst( List data) {
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
                      onTap: () {},
                      leading: CircleAvatar(
                        radius:20.0,
                        backgroundImage: NetworkImage(data[index]["portrait"]),
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
      body: Container(child: lst(data)),

    );
  }
}
