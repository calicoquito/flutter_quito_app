import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'helperclasses/netmanager.dart';
import 'openchatscreen.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
import 'helperclasses/curlyline.dart';
import 'helperclasses/dialogmanager.dart';
import 'helperclasses/urls.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helperclasses/user.dart';
import 'sidedrawer.dart';
import 'package:flutter/widgets.dart';
import 'membersview.dart';
import 'eventsinfo.dart';
import 'eventsinfoedit.dart';
import 'tasklist.dart';
import 'dart:async';
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
  _OpenScreenState createState() => _OpenScreenState(user: user);
}

class _OpenScreenState extends State<OpenScreen>
    with AutomaticKeepAliveClientMixin<OpenScreen> {
  _OpenScreenState({this.user});

  bool isLoading = true; // checks wether the app is still fetching data
  final FirebaseMessaging firebaseMessaging =
      FirebaseMessaging(); // used to receive push notification top the app
  Map projects = Map(); // the projects that the user is involved in
  Map<String, dynamic> channels =
      Map(); // the channel for each chat the user is involved in

  final User user;
  final String url = Urls.projects;
  List data = List();
  WebSocket socket;

  Widget appBarTitle = Text('Projects');
  Icon actionIcon = Icon(Icons.search);
  var respBody;
  List saveimage = List();
  int count = 1;
  List holder = List();
  List completelist = List();

  void setsearchdata() {
    if (count == 1) {
      holder = data;
    }
    setState(() {
      data = data;
    });
    count += 1;
  }

  get stringdata => null;

  @override
  void initState() {
    super.initState();
    getSWData().then((_) {
      setState(() {
        isLoading = false; //Tells when to stop displaying the progres indicator
      });
    });

    // listened fot channel/chat messages
    listenForMessages();
  }

  void dispose() {
    socket.close();
    print('******** OPEN SCREEN DISPOSED**********');
    super.dispose();
  }

  Future getSWData() async {
    NetManager.user = user;
    data = await NetManager.getProjects();
    channels = await NetManager.getChannels();
    if (this.mounted) {
      setState(() {
        projects = NetManager.projects;
        data = data.reversed.toList();
      });
    }
  }

  Future delete(int index) async {
    await DialogManager.delete(
        context, "Are You Sure You Want to delete this project?");
    if (DialogManager.answer == true) {
      var response = await NetManager.delete(data[index]["@id"]);
      if (response == 204) {
        data.removeAt(index);
        getSWData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final User user = Provider.of<User>(context);
    user.projects = NetManager.projects;
    user.channels = NetManager.channels;
    user.channelsByName = NetManager.channelsByName;
    Widget lst(Icon ico, List data) {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: height * 0.15),
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            String start = data[index]["data"]["start"].isEmpty
                ? "None"
                : data[index]["data"]["start"].substring(0, 10);
            String end = data[index]["data"]["end"].isEmpty
                ? "None"
                : data[index]["data"]["end"].substring(0, 10);
            int nummembers = data[index]["data"]["members"] == null
                ? 0
                : data[index]["data"]["members"]
                    .where((member) => member != 'admin')
                    .toList()
                    .length;
            return Card(
                elevation: 5.0,
                child: Column(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: data[index]["data"]["image"] == null
                                ? AssetImage('assets/images/default-image.jpg')
                                : NetworkImage(
                                    data[index]["data"]["image"]["download"],
                                    headers: {
                                        "Accept": "application/json",
                                        "Authorization":
                                            'Bearer ${user.ploneToken}'
                                      }),
                          ),
                        ),
                        height: height * 0.4,
                      ),
                      Container(
                        height: height * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.grey.withOpacity(0.0),
                                  Colors.black54,
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Container(
                        height: height * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                height: height * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "start: $start\n end: $end",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "$nummembers",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          padding: EdgeInsets.only(
                                            left: 4.0,
                                          ),
                                          color: Colors.white,
                                          iconSize: 25,
                                          onPressed: () {
                                            delete(index);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          // padding: EdgeInsets.only(
                                          //   top: height * 0.05,
                                          // ),
                                          color: Colors.white,
                                          iconSize: 25,
                                          onPressed: () async {
                                            bool uploaded =
                                                await Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                              return EventsInfoEdit(
                                                  url: data[index]["@id"],
                                                  user: user);
                                            }));
                                            if (uploaded == true) {
                                              getSWData();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            FlatButton(
                                color: Colors.transparent,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Members(
                                        url: data[index]["@id"], user: user);
                                  }));
                                },
                                child: Container(
                                  height: height * 0.2,
                                )),
                            Container(
                              height: height * 0.1,
                              color: Colors.black38,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    child: Text("${data[index]["title"]} ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.chat),
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    color: Colors.white,
                                    iconSize: 30,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return OpenChatScreen(
                                            title: user.channelsByName[data[index]['data']["id"]]['display_name'],
                                            user: user,
                                            channelId: user.channelsByName[data[index]['data']['id']]['id'],
                                            project: user.projects[data[index]['data']["id"]]);
                                      }));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                    Container(
                      height: height * 0.15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Container(
                                width: width * 0.7,
                                child: Text(
                                  "${data[index]["description"]}",
                                  overflow: TextOverflow.ellipsis,
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  softWrap: true,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black54),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: RaisedButton(
                              elevation: 5,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              shape: StadiumBorder(),
                              child: Text(
                                '${data[index]["data"]["items_total"]} Tasks',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TaskList(
                                    user,
                                    data[index]["@id"],
                                    projectName: data[index]['data']['id'],
                                  );
                                }));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          });
    }

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(),
      appBar: AppBar(title: appBarTitle,
          //backgroundColor: Colors.transparent,
          actions: <Widget>[
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
      body: Stack(
        children: <Widget>[
          data.isEmpty && !isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text('Start something new today'),
                    ),
                    CurlyLine()
                  ],
                )
              : Container(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        await getSWData();
                      },
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : data.length == 0
                              ? Center(
                                  child: Text('Start something new today'),
                                )
                              : Container(
                                  //height: height * 0.60,
                                  child: lst(Icon(Icons.person), data),
                                )),
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

  /*
   * this is a temporary substitute for the push notifications and it is
   * not currently functional. 
   * This method displays a clickable Flushbar with the data regarding new messages 
   * for the user
   */
  void listenForMessages() async {
    try {
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
            if (channels.containsKey(post['channel_id'])) {
              Flushbar(
                  onTap: (flushbar) {
                    flushbar.dismiss();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OpenChatScreen(
                              title: postData['channel_display_name'],
                              user: user,
                              channelId: post['channel_id'],
                              project: projects[postData['channel_name']],
                            )));
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
                      child: projects[postData['channel_name']]["image"] ==
                              null
                          ? Icon(Icons.chat)
                          : null,
                      backgroundImage: projects[postData['channel_name']]
                                  ["image"]["download"] ==
                              null
                          ? null
                          : NetworkImage(
                              projects[postData['channel_name']]["image"]["download"],
                              headers: {
                                "Authorization": 'Bearer ${widget.user.ploneToken}'
                              }
                            ),
                    ),
                    title: Text(
                      user.members[post['user_id']],
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      post['message'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                ..show(context);
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
  // Currently not funtional due to the unresponsive mattermost push proxy
  // void firebaseMessagingInit() async {
  //   firebaseMessaging.configure(onLaunch: (notification) async {
  //     print(notification);
  //   }, onMessage: (notification) async {
  //     print(notification);
  //     Flushbar(
  //       flushbarPosition: FlushbarPosition.TOP,
  //       backgroundColor: Theme.of(context).primaryColor,
  //       duration: Duration(seconds: 3),
  //       messageText: ListTile(
  //         leading: CircleAvatar(
  //           child: Icon(Icons.group),
  //         ),
  //         title: Text(
  //           notification['notification']['title'],
  //           overflow: TextOverflow.ellipsis,
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //         subtitle: Text(
  //           notification['notification']['body'],
  //           overflow: TextOverflow.ellipsis,
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     )..show(context);
  //   }, onResume: (notification) async {
  //     print(notification);
  //   });
  // }

}
