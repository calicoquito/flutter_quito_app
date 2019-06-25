import 'package:flutter/material.dart';
import '../openchatscreen.dart';

/*
 * This class serves to manage how a single chat instance 
 * will be represented and displayed before being clicked
 * on to open
 */

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
        trailing = Checkbox(value: true, onChanged: (_){},);
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