import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    try{
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

        final channels = json.where((channel){
          return widget.user.projects.keys.toList().contains(channel['name']);
        });

        channels.forEach((channel){
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
              chats.add(Chat(title: channel['display_name'], channelId: channel['id'], type: 'group', project: widget.user.projects[channel['name']],));
            });
          }
        }); 
      });
    }
    catch(err){
      print(err);
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: 'No Internet',
        duration: Duration(seconds: 3),
      )..show(context);
    }
    finally{
      setState(() {
        isLoading =false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getChannels();
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
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: (){
              Flushbar(
                duration: Duration(seconds: 2),
                flushbarPosition: FlushbarPosition.BOTTOM,
                icon: Icon(Icons.chat_bubble),
                message: 'Wanna create a chat?',
                mainButton: FlatButton( 
                  child: Text('Yes'),
                  onPressed: (){
                    print('...');
                  },
                ),
              )..show(context);
            }
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
            return Slidable(
              actionExtentRatio: 0.2,
              child: chats[index],
              delegate: SlidableDrawerDelegate(),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  icon: Icons.delete_sweep,
                  color: Theme.of(context).primaryColor,
                  onTap: (){
                    print('deleted');
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
