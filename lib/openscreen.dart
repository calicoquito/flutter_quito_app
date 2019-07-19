import 'package:flutter/material.dart';
import 'events.dart';
import 'sidedrawer.dart';

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
  @override
  OpenScreenState createState() => OpenScreenState();
}

class OpenScreenState extends State<OpenScreen> {
  @override
  void initState(){
    super.initState();
  }

  @override 
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Hero(
        tag:'navdrawer',
        child: SideDrawer()
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context){
                return EventList();
              }
            )
          );
        },
        tooltip: 'New Event',
        child: Icon(Icons.add),
      ),
    );
  }
} 

//Push Notifications from firebase

// void messageListener(){
//     firebaseMessaging.configure(
//       onLaunch: onNotificationReceived,
//       onMessage: onMessageReceived,
//       onResume: onNotificationReceived
//     );
//   }

// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  // Future<dynamic> onNotificationReceived(Map<String, dynamic> message) async{
  //   if(message['data']['sender']!=null){
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => OpenChatScreen(title:message['data']['sender'])
  //       )
  //     );
  //   }
  // }

  // Future<dynamic> onMessageReceived(Map<String, dynamic> message) async {
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('New Message'),
  //     )
  //   );
  // }