import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../openchatscreen.dart';
import 'user.dart';

/*
 * This class serves to manage how a single chat instance 
 * will be represented and displayed before being clicked
 * on to open
 */

/// This [StatefulWidget] holds data coresponding to each of the 
/// chats displayed in the chat screen. This includes the title of the chat, the 
/// channel id from the Mattermost server on which the chat is built

class Chat extends StatefulWidget{
  final String title;
  final String channelId;
  final project;
  final String type;

  @override
  Chat({Key key, this.title, @required this.channelId, this.type, this.project,}): super(key:key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  bool isSelected =false;
  Widget trailing;
  String lastMessage ='';
  String sender = '';

  handleLongPress(){
    if(!isSelected){
      setState((){
        isSelected =true;
        trailing = Checkbox(value: true, onChanged: (_){},);
      });
    }
  }

  handleTap(){
    final User user = Provider.of<User>(context);
    if(isSelected){
      setState(() {
        isSelected =false;
        trailing = null; 
      });
    }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=>OpenChatScreen(title:widget.title, channelId: widget.channelId, user: user, project:widget.project)
        )
      );
    }
  }

  void getMessages() async{
    final user = Provider.of<User>(context);
    final resp = await http.get(
      'http://mattermost.alteroo.com/api/v4/channels/${widget.channelId}/posts?page=0&per_page=30',
      headers: {'Authorization':'Bearer ${user.mattermostToken}', 'Accept':'application/json'}
    );
    final jsonData = jsonDecode(resp.body);
    
    final order = jsonData['order'].reversed.toList();
    final posts = jsonData['posts'];
    
    order.forEach((postId){
      final type = posts[postId]['type'];
      final message = posts[postId]['message'];
      final userId = posts[postId]['user_id'];
      final channelId = posts[postId]['channel_id'];
      if(channelId==widget.channelId && type ==""){ 
        setState(() {
          sender = user.members[userId];
          lastMessage = message;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMessages();
  }

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        selected: isSelected,
        onLongPress: handleLongPress,
        onTap: handleTap,
        leading: CircleAvatar(
          child: (widget.project['thumbnail']==null) 
          ? (widget.type =='direct' ? Icon(Icons.person) : Icon(Icons.group))
          : null,
          backgroundImage: widget.project['thumbnail']==null
          ? null
          : NetworkImage(
            widget.project['thumbnail']
          ),
        ),
        title: Text(widget.title),
        trailing: trailing,
        subtitle: Text.rich(
           TextSpan(
            children: [
              TextSpan(
                text: '$sender: ',
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
              TextSpan(text: lastMessage)
            ]
          ),
        ),
      ),
    );
  }
}