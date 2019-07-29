import 'dart:io';
import 'package:connectivity/connectivity.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'helperclasses/message.dart';
import 'helperclasses/user.dart';

/*
 * This screen defines how the chats will appear when 
 * opened and how they will be animated and managed
 */

// All print statements are temporary and for debugging purposes

class OpenChatScreen extends StatefulWidget{
  final String title;
  final String channelId;
  final User user;

  @override
  OpenChatScreen({Key key, this.title, @required this.channelId, this.user}) : super(key:key);

  @override
  OpenChatScreenState createState() => OpenChatScreenState(); 
}

class OpenChatScreenState extends State<OpenChatScreen>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  WebSocket socket;
  String message; //used to store the message after the controller is cleared so it can still be used
  
  bool isLoading = true;

  List<Widget> messages =[
  ];

  Future<void> connect() async{
    try{
      socket = await WebSocket.connect(
        'ws://mattermost.alteroo.com/api/v4/websocket',
        headers: {'Authorization': 'Bearer ${widget.user.mattermostToken}'}
      );
      int seq = -1; // used to keep track of each data packet
      socket.listen((data){
        final jsonData = jsonDecode(data);
        int newSeq = jsonData['seq'];
        if(seq!=newSeq){
          if (jsonData['event']=='posted'){
            final postData = jsonData['data'];
            final post = jsonDecode(postData['post']);
            
            if(post['user_id']!=widget.user.userId && post['channel_id']==widget.channelId){
              setState(() {
                messages.add(Message(message: post['message'], username: widget.user.members[post['user_id']],type: 'incoming',)); 
              });
              Timer(
                Duration(milliseconds: 100),
                (){
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                }
              );
            }
          }
        }
        else{
          seq = newSeq;
        }
      },
      onError: (err){
        print(err);
      },
      onDone: (){
        print('done');
      });
    }
    catch(err){
      // Flushbar(
      //   flushbarPosition: FlushbarPosition.BOTTOM,
      //   message: 'No Internet',
      //   duration: Duration(seconds: 3),
      // )..show(context);
    }
  }

  Future<void> getMessages() async{
    try {
      final resp = await http.get(
        'http://mattermost.alteroo.com/api/v4/channels/${widget.channelId}/posts?page=0&per_page=30',
        headers: {'Authorization':'Bearer ${widget.user.mattermostToken}', 'Accept':'application/json'}
      );
      final jsonData = jsonDecode(resp.body);
      print(resp.body.substring(500));
      
      final order = jsonData['order'].reversed.toList();
      final posts = jsonData['posts'];
     
      order.forEach((postId){
        final type = posts[postId]['type'];
        final message = posts[postId]['message'];
        final senderId = posts[postId]['user_id'];
        final channelId = posts[postId]['channel_id'];
        if(channelId==widget.channelId && type ==""){
          if(senderId==widget.user.userId){
            setState(() {
              messages.add(Message(message: message, username: "Me", type: 'outgoing',));
            });
          }
          else{
            setState(() {
              messages.add(Message(message: message, username: widget.user.members[senderId], type: 'incoming',));
            });
          }  
        }
      });
    }
    catch(err){
      // Flushbar(
      //   flushbarPosition: FlushbarPosition.BOTTOM,
      //   message: 'No Internet',
      //   duration: Duration(seconds: 3),
      // )..show(context);
    }
  }

  void closeConnection() async{
    if(socket!=null){
      await socket.close();
    }
  }

  void handleSend() async {
    final User user = Provider.of<User>(context);
    final connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none){
      // Flushbar(
      //   flushbarPosition: FlushbarPosition.BOTTOM,
      //   message: "No Internet Connection",
      //   duration: Duration(seconds: 5),
      // )..show(context);
      return;
    }
    if(controller.text.isNotEmpty){
      setState(() {
        messages.add(Message(message: controller.text.trim(), username: "Me", type: 'outgoing',));
        message = controller.text.trim();
        controller.clear();
      });
      http.post(
        'http://mattermost.alteroo.com/api/v4/posts',
        headers: {'Authorization':'Bearer ${user.mattermostToken}'},
        body: jsonEncode({'message':message, 'channel_id':'${widget.channelId}'})
      );
      Timer(
        Duration(milliseconds: 100),
        (){
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      );
    }
  }

  void initialize() async{
    try{
      await getMessages();
      await connect();
    }
    catch(err){
      print(err);
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    initialize();
  }

  @override
  void dispose(){
    closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      //Appbar at the top of the page
      appBar: AppBar(
        elevation: 10.0,
        titleSpacing: 0.0,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(Icons.person, color: Theme.of(context).primaryColor,),
            ),
            SizedBox(width: 5.0,),
            Text(
              widget.title,
              overflow: TextOverflow.fade,
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (index){
              if(index==1){
                Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
              }
            },
            itemBuilder: (context){
              return <PopupMenuItem>[
                PopupMenuItem(
                  child: Text('Chat Settings'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Log out'),
                  value: 1,
                )
              ];
            },
          )
        ],
      ),

      //Contents of the page
      body: RefreshIndicator(
        onRefresh: () async{
          messages.clear();
          return getMessages();
        },
        child: Container(
          child: Column(
            children: <Widget>[
              //This is the area where the chat messages will be displayed
              Flexible(
                child: isLoading ? Center(child: CircularProgressIndicator(),):
                messages.length==0 
                ?Center(child: Text('No messages'))
                :ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index){
                    return messages[index];
                  },
                )
              ),

              //This is the bar at the bottom of the page where text is written to be sent
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded( 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          expands: true,
                          maxLines: null,
                          autocorrect: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            hasFloatingPlaceholder: false,
                            labelText: "Type..."
                          ),
                        ),
                      ),
                    ),
                    //This button sends the message
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.send),
                      onPressed: handleSend
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
