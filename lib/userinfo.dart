import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class User extends StatefulWidget {
  final Map user;
  User({@required this.user});
  UserState createState() => UserState(user: user);
}

class UserState extends State<User> {
  final Map user;
  UserState({@required this.user});


  @override
  Widget build(BuildContext context) {
    print(user);
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
                backgroundImage: NetworkImage(user["portrait"]),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading:  Text('Email: ${user["email"]}' == null ? "" : '${user["email"]}',
            textAlign: TextAlign.left,
            ),
          ),
          Divider(),
          ListTile(
            leading: Text('Phone: ${ user["phone_number"]}' == null ? "" : '${user["phone_number"]}',
            textAlign: TextAlign.left
                ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
