import 'package:flutter/material.dart';
import 'helperclasses/chat.dart';
import 'helperclasses/user.dart';

/*
  This widget describes how the list of chats will be 
  rendered to the screen. For each chat the user is able
  to click on the chat to enter and communicate with
  a next contact
*/

class ChatScreen extends StatefulWidget{
  final User user;

  @override
  ChatScreen({Key key, this.user}):super(key:key);

  @override
  ChatScreenState createState()=> ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  List<Chat> chats =[
    Chat(User(username: 'Javeke', userID:'user1',), title:"Javeke"),
    Chat(User(username: 'Avel', userID:'test_user1',), title:"Avel"),
    Chat(User(username: 'Bruno', userID:'test_user2',), title:"Bruno"),
  ];
  
  void initState(){
    super.initState();
    chats.removeWhere((chat)=>chat.recipient.userID==widget.user.userID);
  }

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
              // setState((){
              //   chats.add(Chat(title: 'New', recipient: widget.user,));
              // });
            },
          )
        ],
      ),
      body: chats.length==0?
      Center(child: Text('No Chats'),)
      :ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index){
          return chats[index];
        },
      ),
    );
  }
}
