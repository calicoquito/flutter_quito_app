import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/openchatscreen.dart';
import 'helperclasses/curlyline.dart';
import 'helperclasses/urls.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helperclasses/user.dart';
import 'sidedrawer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'membersview.dart';
import 'eventsinfo.dart';
import 'eventsinfoedit.dart';
import 'tasks.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
/*
  The OpenScreen Widget defines the screen a user see immediately after
  logging in to the application. 

  Here, the base Scaffold widget is wrapped with a WillPopScope widget 
  which uses the onWillPop property to prevent a user from going back to 
  the login screen after logging out unless he/she wishes to log out of 
  the application.

  The Drawer widget defines a slidable view on the left side of the screen
  where various actions such as logging out and viewing in progress projects
  can be performed. The Drawer also display information on the current logged 
  in user of the app

  The Scaffold's default FloatingActionButton is used to transfer a user 
  the route from which one may create a new project.
*/

class OpenScreen extends StatefulWidget {
  final User user; // the current logged in user's data

  const OpenScreen({Key key, this.user}) : super(key: key);
  @override
  _OpenScreenState createState() => _OpenScreenState(user: user);
}

class _OpenScreenState extends State<OpenScreen> with AutomaticKeepAliveClientMixin<OpenScreen> {
  _OpenScreenState({this.user});

  bool isLoading = true; // checks wether the app is still fetching data 
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging(); // used to receive push notification top the app
  Map projects = Map(); // the projects that the user is involved in 
  Map<String, dynamic> channels = Map(); // the channel for each chat the user is involved in


  final User user;
  final String url = Urls.projects;
  List data = List();
  Widget appBarTitle = Text('Projects');
  Icon actionIcon = Icon(Icons.search);
  List newdata = List();
  var respBody;
  bool internet = true;
  List saveimage = List();
  
  int count = 1;
  List holder = List();
  WebSocket socket;

  get stringdata => null;
  void setsearchdata() {
    if (count == 1) {
      holder = data;
    }
    setState(() {
      data = newdata;
    });
    count += 1;
  }

  /*
   * this is a temporary substitute for the push notifications and it is
   * not currently functional. 
   * This method displays a clickable Flushbar with the data regarding new messages 
   * for the user
   */
  void listenForMessages() async{
    try{
      socket = await WebSocket.connect(
          'ws://mattermost.alteroo.com/api/v4/websocket',
          headers: {'Authorization': 'Bearer ${widget.user.mattermostToken}'});
      int seq = -1;
      socket.listen((data) {
        final jsonData = jsonDecode(data);
        int newSeq = jsonData['seq'];
        if (seq < newSeq) {
          if (jsonData['event'] == 'posted') {
            final postData = jsonData['data'];
            final post = jsonDecode(postData['post']);
            if(channels.containsKey(post['channel_id'])){
              Flushbar(
                onTap: (flushbar){
                  flushbar.dismiss();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:(context)=> OpenChatScreen(
                        title: postData['channel_display_name'],
                        user: user,
                        channelId: post['channel_id'],
                        project: projects[postData['channel_name']],
                      )
                    )
                  );
                },
                titleText: Text(
                  postData['channel_display_name'],
                  overflow: TextOverflow.fade,
                ),
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(8),
                duration: Duration(seconds: 8),
                flushbarPosition: FlushbarPosition.TOP,
                messageText: ListTile(
                  leading: CircleAvatar(
                    child: projects[postData['channel_name']]['thumbnail']==null
                    ?Icon(Icons.chat) 
                    :null,
                    backgroundImage: projects[postData['channel_name']]['thumbnail']==null
                    ?null
                    :NetworkImage(
                      projects[postData['channel_name']]['thumbnail']
                    ) ,
                  ),
                  title: Text(
                    user.members[post['user_id']],
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    post['message'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ) 
              )..show(context);
            }
          }
        } else {
          seq = newSeq;
        }
      });
    } catch (err) {
      print(err);
    }
  }

  // Configures the actions taken by the app on notification received
  // Currently not funtional
  void firebaseMessagingInit() async {
    firebaseMessaging.configure(onLaunch: (notification) async {
      print(notification);
    }, onMessage: (notification) async {
      print(notification);
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
        messageText: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.group),
          ),
          title: Text(
            notification['notification']['title'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            notification['notification']['body'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ),
      )..show(context);
    }, onResume: (notification) async {
      print(notification);
    });
  }

  Future getSWData() async {
    NetManager.user= user;
    data = await NetManager.getProjectsData();
    channels = await NetManager.getChannels();
    projects = NetManager.projects;
    setState(() {
      data = data;
    });
  }

  Future delete(int index) async {
    // print(index);
    // print(data);
    // print(data[index]);
    var response = await NetManager.delete(data[index]["@id"]);
    if (response == 204) {
      data.removeAt(index);
      getSWData();
    }
  }

  @override
  void initState() {
    super.initState();

    //Initializes Firebase Cloud Messaging for push notifications
    //Not currently funcional
    firebaseMessagingInit();

    getSWData()
    .then((_){
      setState((){
        isLoading = false; //Tells when to stop displaying the progres indicator
      });
    });

    // listened fot channel/chat messages
    listenForMessages();
  }

  void dispose(){
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    user.projects = NetManager.projects;
    user.channels = NetManager.channels;
    user.channelsByName = NetManager.channelsByName;

    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              delegate: SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0,1,8,1),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                        onTap: () {
                          //print(index);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TaskList( user, data[index]["@id"],projectName: data[index]['id'],);
                          }));
                        },
                        leading: data[index]["image"] == null
                            ? Image.asset('assets/images/default-image.jpg')
                            : CachedNetworkImage(
                                imageUrl: data[index]["image"],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                width: 80.0,
                              ),
                        trailing: PopupMenuButton<int>(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: FlatButton(
                                    child: Text("Team Members"),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Members(
                                            url: data[index]["@id"], user: user);
                                      }));
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: FlatButton(
                                    child: Text("Move to Top"),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                        ),
                        title: Text("${data[index]["title"]} "),
                        subtitle: Text("Event type: ${data[index]["@type"]}",
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.black54)),
                      ),
                      Divider(
                        height: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () async {
                    bool uploaded = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EventsInfoEdit(
                          url: data[index]["@id"], user: user);
                    }));
                    if (uploaded == true) {
                      getSWData();
                    }
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    delete(index);
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.cyan[100],
      drawer: SideDrawer(),
      appBar: AppBar(title: appBarTitle, actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (actionIcon.icon == Icons.search) {
                actionIcon = Icon(Icons.close);
                appBarTitle = TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white)),
                  onChanged: (text) {
                    if (data.length < holder.length) {
                      data = holder;
                    }
                    text = text.toLowerCase();
                    setState(() {
                      newdata = data.where((project) {
                        var name = project["title"].toLowerCase();
                        return name.contains(text);
                      }).toList();
                    });
                    setsearchdata();
                  },
                );
              } else {
                actionIcon = Icon(Icons.search);
                appBarTitle = Text('Projects');
              }
            });
          },
        ),
      ]),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('Start something new today'),),
              CurlyLine()
            ],
          ),
          Container(
            child: RefreshIndicator(
                onRefresh: () async {
                  getSWData();
                },
                child: isLoading ?
                  Center(child: CircularProgressIndicator(),)
                : data.length ==0 ?
                  Center(child: Text('Start something new today'),)
                :lst(Icon(Icons.person), data)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EventsInfo(user: user);
          }));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
