import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'helperclasses/profile_dialog.dart';

import 'chatscreen.dart';
import 'helperclasses/user.dart';
import 'settings.dart';

class SideDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final User user = Provider.of<User>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context, 
                  builder: (context)=>ProfileDialog()
                );
              },
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                  foregroundColor: Colors.white,
                ),
                accountEmail: Text(user.email),
                accountName: Text(user.username),
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Chat"),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=> ChatScreen(user: Provider.of<User>(context))
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=>Settings()
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await user.logout();
                await http.post(
                  'http://mattermost.alteroo.com/api/v4/users/${user.userId}/sessions/revoke',
                  headers: {'Accept':'application/json', 'Authorization':'Bearer ${user.mattermostToken}'},
                  body: jsonEncode({'session_id':'${user.sessionId}'})
                );
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route)=>false);
              },
            )
          ]
        )
      ),
    );
  }
}
