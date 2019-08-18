import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../openchatscreen.dart';
import 'user.dart';

/*
 * This class serves to manage how a single chat instance 
 * will be represented and displayed before being clicked
 * on to open
 * 
 * 
 * For the context of this application, the words chat and channel 
 * will be used interchangeable as chats are referred to as channels
 * in Mattermost
 * 
 * The chat feature of this app is built on a Mattermost platform 
 * instance
 */

/// This [StatefulWidget] holds data coresponding to each of the 
/// chats displayed in the chat screen. This includes the title of the chat, the 
/// channel id from the Mattermost server on which the chat is built

class Chat extends StatefulWidget{
  final String title; //  the title to be displayed on the appbar
  final String channelId; // the Mattermost channel corresponding to this chat
  final project; // the data related to this chat such as the thumbnail
  final String type; // the type of chat, whether direct or group channel

  @override
  Chat({Key key, this.title, @required this.channelId, this.type, this.project,}): super(key:key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  bool isSelected =false; // is the chat selected
  Widget trailing; //the trailing widget where a checkbox will appear when highlighted
  String lastMessage =''; // the last message in the chat 
  String sender = ''; // the sender of the last message in the chat 


  // Highlights the chat widget when a user holds down on it
  handleLongPress(){
    if(!isSelected){
      setState((){
        isSelected =true;
        trailing = Checkbox(value: true, onChanged: (_){},);
      });
    }
  }

  // unselect the chat widget if it is highlighted and if not goes into the chat
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

  //gets the last message that is sent in the chat/channel 
  void getMessages() async{
    final user = Provider.of<User>(context);
    try{
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
    }on SocketException catch(err){
      print(err);
      Flushbar(
        message: 'No Internet',
        duration: Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.BOTTOM,
      )..show(context);
    }
    catch(err){
      print(err);
    }
  }

  /*
   * The getMessages method has to be called in the didChangeDependencies hook 
   * because it called mutates state which must be manipulated after the 
   * initState hook has completed
   */
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