import 'package:flutter/material.dart';
import 'helperclasses/chat.dart';

/*
  This widget describes how the list of chats will be 
  rendered to the screen. For each chat the user is able
  to click on the chat to enter and communicate with
  a next contact
*/

class ChatScreen extends StatefulWidget{
  @override
  ChatScreenState createState()=> ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  List<Chat> chats = [
    Chat(title:"Javeke"),
    Chat(title:"Avel"),
    Chat(title:"Bruno"),
    Chat(title:"Anthony"),
    Chat(title:"Javier"),
    Chat(title:"Mother"),
    Chat(title:"Klaus"),
    Chat(title:"Elijah"),
    Chat(title:"Rebekah"),
    Chat(title:"Freya"),
    Chat(title:"Hope"),
    Chat(title:"Wanyama"),
    Chat(title:"Hayley"),
    Chat(title:"Kol"),
    Chat(title:"Finn"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefefef),
      appBar: AppBar(
        title: Text(
          'Chats',
          style:TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold
          )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: (){
              setState((){
                chats.add(Chat(title: 'New',));
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: chats
        ),
      ),
    );
  }
}
