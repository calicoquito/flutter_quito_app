import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helperclasses/chat.dart';
import 'package:http/http.dart' as http;
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
  ChatScreen({Key key, @required this.user}):super(key:key);

  @override
  ChatScreenState createState()=> ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  List<Chat> chats = List();
  bool isLoading = true;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  Future<void> getChannels() async{
    List<String> teamEndpoints = widget.user.teams.map((team){
      return 'http://mattermost.alteroo.com/api/v4/users/${widget.user.userId}/teams/${team['id']}/channels';
    }).toList();

    List<Future> requests = teamEndpoints.map((endpoint){
      return http.get(
        endpoint,
        headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
      );
    }).toList();
    
    final responses = await Future.wait(requests).catchError((err){print('Error awaiting all responses');});
    responses.forEach((resp){
      final json = jsonDecode(resp.body);
      json.forEach((channel){
        if(channel['display_name']==""){
          final titleIds = channel['name'].split('_');
          if(titleIds[0]==widget.user.userId && titleIds.length ==3){
            setState(() {
              chats.add(Chat(title: widget.user.members[titleIds[2]], channelId: channel['id'], type: 'direct',));
            });
          }
          else{
            setState(() {
              chats.add(Chat(title: widget.user.members[titleIds[0]], channelId: channel['id'], type: 'direct',));
            });
          }
        }
        else{
          setState(() {
            chats.add(Chat(title: channel['display_name'], channelId: channel['id'], type: 'group',));
          });
        }
      }); 
    });
  }

  @override
  void initState(){
    super.initState();
      getChannels()
      .then((_){
        setState(() {
          isLoading =false;
        });
    });
  }

  @override
  void dispose() {
    print('Chat Screen disposed');
    super.dispose();
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
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Dialog(
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Name'
                        ),
                      ),
                    ),
                  ),
                )
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          chats.clear();
          return getChannels();
        },
        child: isLoading ? Center(child: CircularProgressIndicator(),): 
         chats.length==0
        ? Center(child: Text('No Chats'),)
        :ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index){
          return chats[index];
          },
        ),
      ),
    );
  }
}
