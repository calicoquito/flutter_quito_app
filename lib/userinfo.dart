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
      body: ListView(
        children: <Widget>[
          Container(
            height: 200.0,
            child: Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: userinfo["portrait"] == null 
                ? AssetImage('assets/images/default-image.jpg')
                : NetworkImage(userinfo["portrait"]),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          ListTile(
            leading:  Text(userinfo["email"] == null ? 'Email:'  : 'Email: ${userinfo["email"]}',
            textAlign: TextAlign.left,
            ),
          ),
          ListTile(
            leading: Text(userinfo["phone_number"] == null ? "Phone:" : 'Phone: ${userinfo["phone_number"]}',
            textAlign: TextAlign.left
                ),
          ),
        ],
      ),
    );
  }
}
