import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget{
  @override
  ChatScreenState createState() => ChatScreenState(); 
}

class ChatScreenState extends State<ChatScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chat),
        title: Text("Chat"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.1,
              child: Container(color: Colors.redAccent,)
            )
          ],
        )
      ),
    );
  }
}