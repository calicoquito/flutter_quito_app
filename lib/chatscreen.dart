import 'package:flutter/material.dart';
import 'openchatscreen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style:TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold
          )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: (){
              print('New chat created');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Chat(title:"Javeke"),
            Chat(title:"Avel"),
            Chat(title:"Bruno"),
            Chat(title:"Anthony"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Wanyama"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
            Chat(title:"Javeke"),
          ]
        ),
      ),
    );
  }
}

class Chat extends StatefulWidget{
  @override
  Chat({Key key, this.title}): super(key:key);
  final String title;

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  bool isSelected =false;
  Widget trailing;

  handleLongPress(){
    if (!isSelected){
      setState((){
        isSelected =true;
        trailing = Checkbox(value: true, onChanged: (bool value){},);
      });
    }
  }

  handleTap(){
    if(isSelected){
      setState(() {
        isSelected =false;
        trailing = null; 
      });
    }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=>OpenChatScreen(title:widget.title)
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        selected: isSelected,
        onLongPress: handleLongPress,
        onTap: handleTap,
        leading: CircleAvatar(child:Icon(Icons.person)),
        title: Text(widget.title),
        trailing: trailing,
      ),
    );
  }
}