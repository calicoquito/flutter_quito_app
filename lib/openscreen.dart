import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
import 'helperclasses/dialogmanager.dart';
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
  the route from which one may create a  project.
*/

class OpenScreen extends StatefulWidget {
  final User user;

  const OpenScreen({Key key, this.user}) : super(key: key);
  @override
  OpenScreenState createState() => OpenScreenState(user: user);
}

class OpenScreenState extends State<OpenScreen> {
  bool isLoading = true;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final User user;
  final String url = Urls.projects;
  OpenScreenState({this.user});
  List data = List();
  Widget appBarTitle = Text('Projects');
  Icon actionIcon = Icon(Icons.search);
  var respBody;
  bool internet = true;
  List saveimage = List();
  Map projects = Map();

  int count = 1;
  List holder = List();
  WebSocket socket;
  List completelist = List();
  get stringdata => null;
  void setsearchdata() {
    if (count == 1) {
      holder = data;
    }
    setState(() {
      data = data;
    });
    count += 1;
  }

  void listenForMessages() async {
    try {
      socket = await WebSocket.connect(
          'ws://mattermost.alteroo.com/api/v4/websocket',
          headers: {'Authorization': 'Bearer ${widget.user.mattermostToken}'});
      int seq = -1;
      socket.listen((data) {
        final jsonData = jsonDecode(data);
        int Seq = jsonData['seq'];
        if (seq < Seq) {
          if (jsonData['event'] == 'posted') {
            final postData = jsonData['data'];
            final post = jsonDecode(postData['post']);
            Flushbar(
                backgroundColor: Theme.of(context).primaryColor,
                duration: Duration(seconds: 3),
                flushbarPosition: FlushbarPosition.TOP,
                messageText: ListTile(
                  title: Text('Channel'),
                  subtitle: Text(post['message']),
                ))
              ..show(context);
          }
        } else {
          seq = Seq;
        }
      });
    } catch (err) {
      print(err);
    }
  }

  //Configures the actions taken by the app on notification received
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

  @override
  void initState() {
    super.initState();
    //Gets Firebase Cloud Messaging device token for push notifications
    firebaseMessaging.getToken().then((token) {
      //print(token);
    });
    listenForMessages();
    firebaseMessagingInit();
    getSWData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void dispose() {
    socket.close();
    super.dispose();
  }

  Future getSWData() async {
    data = await NetManager.getProjectsData();
    setState(() {
      data = data;
      //print(data);
    });
    for (var project in data) {
      await gettasksdata(project['@id']);
    }
  }

  Future getLargeImage(int index) async {
    String link = await NetManager.getLargeImage(index, data[index]["@id"]);
    return Image.network(
      link,
    );
  }

  gettasksdata(String url) async {
    int complete = 0;
    var list = await NetManager.getTasksData(url);
    for (var task in list) {
      Map taskinfo = await NetManager.getTask(task['@id']);
      if (taskinfo["complete"] == true) {
        complete += 1;
      }
    }
    completelist.add([complete, list.length]);
  }

  Future delete(int index) async {
    var response = await NetManager.delete(data[index]["@id"]);
    if (response == 204) {
      data.removeAt(index);
      getSWData();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final User user = Provider.of<User>(context);
    user.projects = projects;
    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            int complete = Random().nextInt(10);
            completelist[index] =
                completelist[index] == null ? [0, 0] : completelist[index];
            return Slidable(
              delegate: SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskList(
                            user,
                            data[index]["@id"],
                          );
                        }));
                      },
                      leading: GestureDetector(
                        onTap: () async {
                          var image = await getLargeImage(index);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0),
                                // title: Text("Alert Dialog title"),
                                content: image == null
                                    ? Image.asset(
                                        'assets/images/default-image.jpg')
                                    : image,
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  FlatButton(
                                    child: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Icon(Icons.info),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(5.0),
                              child: data[index]["image"] == null
                                  ? Image.asset(
                                      'assets/images/default-image.jpg')
                                  : CachedNetworkImage(
                                      imageUrl: data[index]["image"],
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Members(url: data[index]["@id"], user: user);
                          }));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 3.0,
                              animation: true,
                              percent: completelist[index][0] * .1,
                              center: new Text("${(completelist[index][0])}"),
                              progressColor: Color(0xff7e1946)),
                        ),
                      ),
                      title: Text("${data[index]["title"]} ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500)),
                      subtitle: Text("Event type: ${data[index]["@type"]}",
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black54)),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
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
                    await DialogManager.delete(context, "Are You Sure You Want to delete this project?");
                    if (DialogManager.answer == true ) {
                      delete(index);
                    }
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
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
                      data = data.where((project) {
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
      body: Container(
        child: RefreshIndicator(
            onRefresh: () async {
              getSWData();
            },
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : data == null
                    ? Center(
                        child: Text('Start something  today'),
                      )
                    : lst(Icon(Icons.person), data)),
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
}
