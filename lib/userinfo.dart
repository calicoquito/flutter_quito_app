import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserInfo extends StatefulWidget {
  final Map userinfo;
  UserInfo({@required this.userinfo});
 UserInfoState createState() => UserInfoState(userinfo: userinfo);
}

class UserInfoState extends State<UserInfo> {
  final Map userinfo;
  UserInfoState({@required this.userinfo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Profile',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            child: Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(userinfo["portrait"]),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading:  Text('Email: ${userinfo["email"]}' == null ? "" : '${userinfo["email"]}',
            textAlign: TextAlign.left,
            ),
          ),
          Divider(),
          ListTile(
            leading: Text('Phone: ${ userinfo["phone_number"]}' == null ? "" : '${userinfo["phone_number"]}',
            textAlign: TextAlign.left
                ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
