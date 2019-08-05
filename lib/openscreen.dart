import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
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
  final User user;

  const OpenScreen({Key key, this.user}) : super(key: key);
  @override
  OpenScreenState createState() => OpenScreenState(user: user);
}

class OpenScreenState extends State<OpenScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final User user;
  final String url = Urls.projects;
  OpenScreenState({this.user});
  List data = List();
  Widget appBarTitle = Text('Projects');
  Icon actionIcon = Icon(Icons.search);
  List newdata = List();
  var respBody;
  bool internet = true;
  List saveimage = List();
  Map projects = Map();

  int count = 1;
  List holder = List();

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

  //Configures the actions taken by the app on notification received
  void firebaseMessagingInit() async {
    firebaseMessaging.configure(onLaunch: (notification) async {
      print('onLaunch');
      print(notification);
    }, onMessage: (notification) async {
      print('onMessage');
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
      print('onResume');
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
    firebaseMessagingInit();
    getSWData();
  }

  Future getSWData() async {
    data = await NetManager.getProjectsData();
    setState(() {
      data = data;
      print(data);
    });
  }

  Future delete(int index) async {
    var response = await NetManager.deleteProject(index, data);
    if (response.body == 204) {
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
                        print(index);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskList(
                            url: data[index]["@id"],
                            user: user,
                          );
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
                  onTap: () async{
                    data.removeAt(index);
                    delete(index);
                    getSWData();
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
      body: Container(
        child: RefreshIndicator(
            onRefresh: () async {
              getSWData();
            },
            child: lst(Icon(Icons.person), data)),
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
