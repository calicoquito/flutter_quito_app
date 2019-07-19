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
  @override
  ChatScreenState createState()=> ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  List<Chat> chats = List();
  User currentUser = User();
  String mattermostToken;
  List<Map<String, String>> teams = List();
  Map<String, String> members  = Map();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> mattermostLogin() async {
    final resp = await http.post(
      'http://mattermost.alteroo.com/api/v4/users/login',
      headers: {'Accept':'application/json', 'Content-Type':'application/json'},
      body: jsonEncode({'login_id':'user1', 'password':'user1'})
    );
    final json = jsonDecode(resp.body);
    currentUser.userId = json['id'];
    currentUser.mattermostToken = resp.headers['token'];
  }

  Future<void> getUserTeams()async{
    final resp = await http.get(
      'http://mattermost.alteroo.com/api/v4/users/${currentUser.userId}/teams',
      headers: {'Authorization':'Bearer ${currentUser.mattermostToken}'}
    );
    final json = jsonDecode(resp.body);
    json.forEach((team){
      teams.add({team['id']:team['name']});
    });
  }

  void getTeamMemebers() {
    try{
      teams.forEach((team) async{
        final resp = await http.get(
        'http://mattermost.alteroo.com/api/v4/users?team=${team.keys.toList()[0]}',
        headers: {'Authorization':'Bearer ${currentUser.mattermostToken}'}
        );
        final jsonData = jsonDecode(resp.body);

        jsonData.forEach((member){
          members.addAll({member['id']: member['username']});
        });
        currentUser.members=members;
      });
    }
    catch(err){
      print(err);
    }
  }

  Future<void> getUsersChannels() async{
    List<String> teamEndpoints = teams.map((team){
      return 'http://mattermost.alteroo.com/api/v4/users/${currentUser.userId}/teams/${team.keys.toList()[0]}/channels';
    }).toList();

    List<Future> requests = teamEndpoints.map((endpoint){
      return http.get(
        endpoint,
        headers: {'Authorization':'Bearer ${currentUser.mattermostToken}'}
      );
    }).toList();
    final responses = await Future.wait(requests).catchError((err){print('Error awaiting all responses');});
    
    responses.forEach((resp){
      final json = jsonDecode(resp.body);
      json.forEach((channel){
        setState(() {
          chats.add(Chat(title: channel['display_name'], channelId: channel['id'],));
        });
      });
    });
  }

  @override
  void initState(){
    super.initState();
    mattermostLogin()
    .then((_){
      getUserTeams()
      .then((__){
        getUsersChannels();
        getTeamMemebers();
      });
    })
    .catchError((err){print(err);});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    user.mattermostToken = currentUser.mattermostToken;
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
          print('Refreshing...');
          return;
        },
        child: ListView.builder(
          itemCount: chats.length==0? 1: chats.length,
          itemBuilder: (context, index){
            if(chats.length==0){
              return Center(child: Text('No Chats'),);
            }
          return chats[index];
          },
        ),
      ),
    );
  }
}
