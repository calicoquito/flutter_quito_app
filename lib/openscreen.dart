import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quito_1/events.dart';
import 'package:quito_1/sidedrawer.dart';
import 'helperclasses/user.dart';
import 'openchatscreen.dart';


/*
  The OpenScreen Widget defines the screen a user see immediately after
  logging in to the application. 

  Here, the base Scaffold widget is wrapped with a WillPopScope widget 
  which uses the onWillPop property to prevent a user from going back to 
  the login screen after logging out unless he/she wishes to log out of 
  the application.

  The Drawer widget defines a slidable view on the left side of the screen
  where various actions such as logging out and viewing in progress projects
  can be performed. The Drawer also display information on the current logged 
  in user of the app

  The Scaffold's default FloatingActionButton is used to transfer a user 
  the route from which one may create a new project.
*/

class OpenScreen extends StatefulWidget {
  OpenScreen({Key key, this.user}) : super(key: key);
  final User user;

  @override
  OpenScreenState createState() => OpenScreenState();
}

class OpenScreenState extends State<OpenScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<dynamic> onNotificationReceived(Map<String, dynamic> message) async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OpenChatScreen(title:message['data']['sender'])
      )
    );
  }

  Future<dynamic> onMessageReceived(Map<String, dynamic> message) async {
    print("${message['data']['sender']} sent ${message['data']}");
  }

  void messageListener(){
    firebaseMessaging.configure(
      onLaunch: onNotificationReceived,
      onMessage: onMessageReceived,
      onResume: onNotificationReceived
    );
  }

  @override
  void initState(){
    super.initState();
    firebaseMessaging.subscribeToTopic('chats');
    messageListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Hero(
          tag:'navdrawer',
          child: SideDrawer(user:widget.user)
        ),
        appBar: AppBar(
          title: Text('Welcome'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Start something new today',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
