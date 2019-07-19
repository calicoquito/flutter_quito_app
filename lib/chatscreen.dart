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
  String mattermostToken;
  List<Map<String, String>> teams = List();
  Map<String, String> members  = Map();
  bool isLoading = true;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> getTeams() async {
    final resp = await http.get(
      'http://mattermost.alteroo.com/api/v4/users/${widget.user.userId}/teams',
      headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
    );
    final json = jsonDecode(resp.body);
    json.forEach((team){
      teams.add({team['id']:team['name']});
    });
    for (var team in teams){
      final resp = await http.get(
        'http://mattermost.alteroo.com/api/v4/users?team=${team.keys.toList()[0]}',
        headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
      );
      final jsonData = jsonDecode(resp.body);
      jsonData.forEach((member){
        members.addAll({member['id']: member['username']});
      });
    }
  }


  Future<void> getChannels() async{
    List<String> teamEndpoints = teams.map((team){
      return 'http://mattermost.alteroo.com/api/v4/users/${widget.user.userId}/teams/${team.keys.toList()[0]}/channels';
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
              chats.add(Chat(title: members[titleIds[2]], channelId: channel['id'],));
            });
          }
          else{
            setState(() {
              chats.add(Chat(title: members[titleIds[0]], channelId: channel['id'],));
            });
          }
        }
        else{
          setState(() {
            chats.add(Chat(title: channel['display_name'], channelId: channel['id'],));
          });
        }
      }); 
    });
  }

  @override
  void initState(){
    super.initState();
    getTeams()
    .then((_){
      getChannels()
      .then((__){
        setState(() {
          isLoading =false;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    user.members = members;
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
