import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'helperclasses/user.dart';
import 'sidedrawer.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'membersview.dart';
import 'dart:convert';
import 'eventsinfo.dart';
import 'eventsinfoedit.dart';
import 'tasks.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
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
  OpenScreenState createState() => OpenScreenState();
}

class OpenScreenState extends State<OpenScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String url = "http://calico.palisadoes.org/projects";
  List data = List();
  Widget appBarTitle = Text('Projects');
  Icon actionIcon = Icon(Icons.search);
  List newdata = List();
  var respBody;

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
      //print(notification);
    }, onMessage: (notification) async {
      //print(notification);
      // Flushbar(
      //   flushbarPosition: FlushbarPosition.BOTTOM,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   duration: Duration(seconds: 3),
      //   messageText: Text(
      //     notification['notification']['body'],
      //     overflow: TextOverflow.ellipsis,
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      // )..show(context);
    }, onResume: (notification) async {
      //print(notification);
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

  Future getSaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //print(prefs.getString('stringdata'));
      data = prefs.getString('stringdata') == null
          ? null
          : json.decode(prefs.getString('stringdata'));
    });
    return "Success!";
  }

  Future setSaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String stringdata = json.encode(data);
      prefs.setString('stringdata', stringdata);
    });
  }

  Future getSWData() async {
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authentication": 'Bearer ${widget.user.ploneToken}'
      });
      print(response);
      var resBody = json.decode(response.body);
      data = resBody["items"];
      for (var i in data) {
        i = i as Map;
      }

      Future<String> getimglink(int i) async {
        try {
          var resp = await http.get(data[i]["@id"], headers: {
            "Accept": "application/json",
            "Authentication": 'Bearer ${widget.user.ploneToken}'
          });
          print(resp.statusCode);
          respBody = json.decode(resp.body);
          if (respBody != null) {
            return respBody["image"]["scales"]["thumb"]["download"];
          }
        } catch (e) {}
      }

      for (var i = 1; i <= data.length; i++) {
        var imgs = await getimglink(i);
        if (imgs != null) {
          data[i] = data[i];
          data[i]['image'] = imgs;
        }
      }

      if (data.isEmpty) {
        getSaveData();
      } else {
        setState(() {
          data = data;
          setSaveData();
        });
      }

      return "Success!";
    } catch (err) {
      print(err);
    }
  }

  Future delete(int index) async {
    String url = data[index]["@id"];
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    try {
      var resp = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${widget.user.ploneToken}'
        },
      );
      print(resp.statusCode);
      return "Success!";
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskList(url: data[index]["@id"]);
                        }));
                      },
                      leading: CircleAvatar(
                        radius: 28.0,
                        backgroundImage: data[index]["image"] == null
                            ? AssetImage('assets/images/default-image.jpg')
                            : NetworkImage(
                                data[index]["image"],
                              ),
                        backgroundColor: Colors.transparent,
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
                                      return Members(url: data[index]["@id"]);
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
                      title: Text("Event Name: ${data[index]["title"]} "),
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
                  onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EventsInfoEdit(url: data[index]["@id"]);
                      })),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    data.removeAt(index);
                    delete(index);
                  },
                ),
              ],
            );
          });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              return EventsInfo(
                url: url,
              );
            }));
          },
        ),
      ),
    );
  }
}
