// import 'dart:io';
// import 'dart:convert';
// import 'dart:math';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'helperclasses/netmanager.dart';
// import 'openchatscreen.dart';
// import 'package:quito_1/helperclasses/netmanager.dart';
// import 'helperclasses/curlyline.dart';
// import 'helperclasses/dialogmanager.dart';
// import 'helperclasses/urls.dart';
// import 'package:flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'helperclasses/user.dart';
// import 'sidedrawer.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'membersview.dart';
// import 'eventsinfo.dart';
// import 'eventsinfoedit.dart';
// import 'tasklist.dart';
// import 'dart:async';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// /*
//   The OpenScreen Widget defines the screen a user see immediately after
//   logging in to the application. 
//   Here, the base Scaffold widget is wrapped with a WillPopScope widget 
//   which uses the onWillPop property to prevent a user from going back to 
//   the login screen after logging out unless he/she wishes to log out of 
//   the application.
//   The Drawer widget defines a slidable view on the left side of the screen
//   where various actions such as logging out and viewing in progress projects
//   can be performed. The Drawer also display information on the current logged 
//   in user of the app
//   The Scaffold's default FloatingActionButton is used to transfer a user 
//   the route from which one may create a  project.
// */

// class OpenScreen extends StatefulWidget {
//   final User user;

//   const OpenScreen({Key key, this.user}) : super(key: key);
//   @override
//   _OpenScreenState createState() => _OpenScreenState(user: user);
// }

// class _OpenScreenState extends State<OpenScreen>
//     with AutomaticKeepAliveClientMixin<OpenScreen> {
//   _OpenScreenState({this.user});

//   bool isLoading = true; // checks wether the app is still fetching data
//   final FirebaseMessaging firebaseMessaging =
//       FirebaseMessaging(); // used to receive push notification top the app
//   Map projects = Map(); // the projects that the user is involved in
//   Map<String, dynamic> channels =
//       Map(); // the channel for each chat the user is involved in

//   final User user;
//   final String url = Urls.projects;
//   List data = List();

//   WebSocket socket;
//   ImageProvider mainImage = AssetImage('assets/images/default-image.jpg');
//   int selectedIndex = 0;

//   get stringdata => null;

//   @override
//   void initState() {
//     super.initState();
//     getSWData().then((_) {
//       setState(() {
//         isLoading = false; //Tells when to stop displaying the progres indicator
//       });
//     });

//     // listened fot channel/chat messages
//     listenForMessages();
//   }

//   void dispose() {
//     socket.close();
//     print('******** OPEN SCREEN DISPOSED**********');
//     super.dispose();
//   }

//   Future getSWData() async {
//     NetManager.user = user;
//     data = await NetManager.getProjectsData();
//     channels = await NetManager.getChannels();
//     if (data != null) {
//       _onSelected(0);
//     }
//     if (this.mounted) {
//       setState(() {
//         projects = NetManager.projects;
//         data = data;
//       });
//     }
//   }

//   Future getLargeImage(int index) async {
//     String link = await NetManager.getLargeImage(index, data[index]["@id"]);
//     return Image.network(
//       link,
//     );
//   }

//   _onSelected(int index) async {
//     setState(() {
//       selectedIndex = index;
//     });
//     String imglink = await NetManager.getLargeImage(index, data[index]["@id"]);
//     var imgfile = await DefaultCacheManager().getSingleFile(imglink, headers: {
//       "Accept": "application/json",
//       "Authorization": 'Bearer ${user.ploneToken}'
//     });
//     setState(() {
//       mainImage = FileImage(imgfile);
//     });
//   }

//   Future delete(int index) async {
//     await DialogManager.delete(
//         context, "Are You Sure You Want to delete this project?");
//     if (DialogManager.answer == true) {
//       var response = await NetManager.delete(data[index]["@id"]);
//       if (response == 204) {
//         data.removeAt(index);
//         getSWData();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     double height = MediaQuery.of(context).size.height;
//     final User user = Provider.of<User>(context);
//     user.projects = NetManager.projects;
//     user.channels = NetManager.channels;
//     user.channelsByName = NetManager.channelsByName;
//     Widget lst(Icon ico, List data) {
//       return ListView.builder(
//           padding: EdgeInsets.only(bottom: height * 0.15),
//           itemCount: data == null ? 0 : data.length,
//           itemBuilder: (BuildContext context, int index) {
            
//             return Container(
//               color: selectedIndex == index ? Colors.grey[200] : Colors.white,
//               child: Slidable(
//                 delegate: SlidableDrawerDelegate(),
//                 actionExtentRatio: 0.25,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     ListTile(
//                       contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
//                       onTap: () {
//                         if (selectedIndex != index) {
//                           _onSelected(index);
//                         }
//                       },
//                       leading: GestureDetector(
//                         onTap: () async {
//                           var image = await getLargeImage(index);
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               // return object of type Dialog
//                               return AlertDialog(
//                                 contentPadding: EdgeInsets.all(0),
//                                 // title: Text("Alert Dialog title"),
//                                 content: image == null
//                                     ? Image.asset(
//                                         'assets/images/default-image.jpg')
//                                     : image,
//                                 actions: <Widget>[
//                                   // usually buttons at the bottom of the dialog
//                                   FlatButton(
//                                     child: Icon(Icons.close),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   FlatButton(
//                                     child: Icon(Icons.edit),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   FlatButton(
//                                     child: Icon(Icons.info),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: GestureDetector(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
//                             child: ClipRRect(
//                               borderRadius: new BorderRadius.circular(5.0),
//                               child: data[index]["thumbnail"] == null
//                                   ? Image.asset(
//                                       'assets/images/default-image.jpg')
//                                   : Image.network(data[index]["thumbnail"],
//                                       headers: {
//                                           "Accept": "application/json",
//                                           "Authorization":
//                                               'Bearer ${user.ploneToken}'
//                                         }
//                                       // placeholder: (context, url) =>
//                                       //     CircularProgressIndicator(),
//                                       ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       trailing: Padding(
//                         padding: EdgeInsets.only(right: 10.0),
//                         child: RaisedButton(
//                           padding: EdgeInsets.symmetric(horizontal: 10.0),
//                           shape: StadiumBorder(),
//                           child: Text(
//                             '${Random().nextInt(4) + 1} Tasks',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13.0,
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (context) {
//                               return TaskList(
//                                 user,
//                                 data[index]["@id"],
//                                 projectName: data[index]['id'],
//                               );
//                             }));
//                           },
//                         ),
//                       ),
//                       title: Text("${data[index]["title"]} ",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 18.0,
//                               color: Colors.grey[800],
//                               fontWeight: FontWeight.w500)),
//                       subtitle: Text("Event type: ${data[index]["@type"]}",
//                           style:
//                               TextStyle(fontSize: 15.0, color: Colors.black54)),
//                     ),
//                     Divider(
//                       height: 1.0,
//                     ),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   IconSlideAction(
//                     caption: 'Edit',
//                     color: Colors.blue,
//                     icon: Icons.edit,
//                     onTap: () async {
//                       bool uploaded = await Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return EventsInfoEdit(
//                             url: data[index]["@id"], user: user);
//                       }));
//                       if (uploaded == true) {
//                         getSWData();
//                       }
//                     },
//                   ),
//                 ],
//                 secondaryActions: <Widget>[
//                   IconSlideAction(
//                     caption: 'Delete',
//                     color: Colors.red,
//                     icon: Icons.delete,
//                     onTap: () {
//                       delete(index);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           });
//     }

//     final GlobalKey<ScaffoldState> _scaffoldKey =
//         new GlobalKey<ScaffoldState>();
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: SideDrawer(),
//       body: Stack(
//         children: <Widget>[
//           data.isEmpty && !isLoading
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Center(
//                       child: Text('Start something new today'),
//                     ),
//                     CurlyLine()
//                   ],
//                 )
//               : Container(
//                   child: RefreshIndicator(
//                       onRefresh: () async {
//                         await getSWData();
//                       },
//                       child: isLoading
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : data.length == 0
//                               ? Center(
//                                   child: Text('Start something new today'),
//                                 )
//                               : Column(
//                                   children: <Widget>[
// /////////////////////////////////////////////////////////////
//                                     Stack(children: <Widget>[
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                           image: DecorationImage(
//                                             fit: BoxFit.fitWidth,
//                                             image: mainImage == null
//                                                 ? AssetImage(
//                                                     'assets/images/default-image.jpg')
//                                                 : mainImage,
//                                           ),
//                                         ),
//                                         height: height * 0.4,
//                                       ),
//                                       Container(
//                                         height: height * 0.4,
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             gradient: LinearGradient(
//                                                 begin: Alignment.bottomCenter,
//                                                 end: Alignment.topCenter,
//                                                 colors: [
//                                                   Colors.grey.withOpacity(0.0),
//                                                   Colors.black54,
//                                                 ],
//                                                 stops: [
//                                                   0.0,
//                                                   1.0
//                                                 ])),
//                                       ),
//                                       Container(
//                                         height: height * 0.4,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Container(
//                                                 height: height * 0.1,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: <Widget>[
//                                                     IconButton(
//                                                       splashColor:
//                                                           Colors.white10,
//                                                       icon: Icon(Icons.menu),
//                                                       padding: EdgeInsets.only(
//                                                           top: height * 0.05,
//                                                           left: 10.0),
//                                                       color: Colors.white,
//                                                       iconSize: 30,
//                                                       onPressed: () {
//                                                         _scaffoldKey
//                                                             .currentState
//                                                             .openDrawer();
//                                                       },
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: <Widget>[
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) {
//                                                               return Members(
//                                                                   url: data[
//                                                                           selectedIndex]
//                                                                       ["@id"],
//                                                                   user: user);
//                                                             }));
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                               top:
//                                                                   height * 0.05,
//                                                               right: 8.0,
//                                                             ),
//                                                             child:
//                                                                 CircularPercentIndicator(
//                                                                     radius:
//                                                                         25.0,
//                                                                     lineWidth:
//                                                                         3.0,
//                                                                     animation:
//                                                                         true,
//                                                                     percent:
//                                                                         (Random().nextInt(7) + 1) *
//                                                                             .1,
//                                                                     center:
//                                                                         Text(
//                                                                       "${Random().nextInt(4) + 1}",
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.white),
//                                                                     ),
//                                                                     progressColor:
//                                                                         Color(
//                                                                             0xff7e1946)),
//                                                           ),
//                                                         ),
//                                                         IconButton(
//                                                           icon: Icon(
//                                                               Icons.delete),
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                             top: height * 0.05,
//                                                           ),
//                                                           color: Colors.white,
//                                                           iconSize: 25,
//                                                           onPressed: () {
//                                                             delete(
//                                                                 selectedIndex);
//                                                           },
//                                                         ),
//                                                         IconButton(
//                                                           icon:
//                                                               Icon(Icons.edit),
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                             top: height * 0.05,
//                                                           ),
//                                                           color: Colors.white,
//                                                           iconSize: 25,
//                                                           onPressed: () async {
//                                                             bool uploaded =
//                                                                 await Navigator.push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder:
//                                                                             (context) {
//                                                               return EventsInfoEdit(
//                                                                   url: data[
//                                                                           selectedIndex]
//                                                                       ["@id"],
//                                                                   user: user);
//                                                             }));
//                                                             if (uploaded ==
//                                                                 true) {
//                                                               getSWData();
//                                                             }
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 )),
//                                             Container(
//                                               height: height * 0.1,
//                                               color: Colors.black38,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 10.0,
//                                                     ),
//                                                     child: Text(
//                                                         "${data[selectedIndex]["title"]} ",
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextStyle(
//                                                             fontSize: 20.0,
//                                                             color: Colors.white,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500)),
//                                                   ),
//                                                   IconButton(
//                                                     icon: Icon(Icons.chat),
//                                                     padding: EdgeInsets.only(
//                                                       left: 10.0,
//                                                     ),
//                                                     color: Colors.white,
//                                                     iconSize: 30,
//                                                     onPressed: () {
//                                                       Navigator.of(context).push(
//                                                           MaterialPageRoute(
//                                                               builder:
//                                                                   (context) {
//                                                         return OpenChatScreen(
//                                                             title: user.channelsByName[
//                                                                     data[selectedIndex]
//                                                                         ["id"]][
//                                                                 'display_name'],
//                                                             user: user,
//                                                             channelId: user.channelsByName[
//                                                                     data[selectedIndex]
//                                                                         ["id"]]
//                                                                 ['id'],
//                                                             project: user.projects[
//                                                                 data[selectedIndex]
//                                                                     ["id"]]);
//                                                       }));
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ]),
// /////////////////////////////////////////////////////////////
//                                     Container(
//                                       height: height * 0.60,
//                                       child: lst(Icon(Icons.person), data),
//                                     )
//                                   ],
//                                 )),
//                 ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return EventsInfo(user: user);
//           }));
//         },
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;

//   /*
//    * this is a temporary substitute for the push notifications and it is
//    * not currently functional. 
//    * This method displays a clickable Flushbar with the data regarding new messages 
//    * for the user
//    */
//   void listenForMessages() async {
//     try {
//       socket = await WebSocket.connect(
//           'ws://mattermost.alteroo.com/api/v4/websocket',
//           headers: {'Authorization': 'Bearer ${widget.user.mattermostToken}'});
//       int seq = -1;
//       socket.listen((data) {
//         final jsonData = jsonDecode(data);
//         int newSeq = jsonData['seq'];
//         if (seq < newSeq) {
//           if (jsonData['event'] == 'posted') {
//             final postData = jsonData['data'];
//             final post = jsonDecode(postData['post']);
//             if (channels.containsKey(post['channel_id'])) {
//               Flushbar(
//                   onTap: (flushbar) {
//                     flushbar.dismiss();
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => OpenChatScreen(
//                               title: postData['channel_display_name'],
//                               user: user,
//                               channelId: post['channel_id'],
//                               project: projects[postData['channel_name']],
//                             )));
//                   },
//                   titleText: Text(
//                     postData['channel_display_name'],
//                     overflow: TextOverflow.fade,
//                   ),
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.all(8),
//                   duration: Duration(seconds: 8),
//                   flushbarPosition: FlushbarPosition.TOP,
//                   messageText: ListTile(
//                     leading: CircleAvatar(
//                       child: projects[postData['channel_name']]['thumbnail'] ==
//                               null
//                           ? Icon(Icons.chat)
//                           : null,
//                       backgroundImage: projects[postData['channel_name']]
//                                   ['thumbnail'] ==
//                               null
//                           ? null
//                           : NetworkImage(
//                               projects[postData['channel_name']]['thumbnail']),
//                     ),
//                     title: Text(
//                       user.members[post['user_id']],
//                       overflow: TextOverflow.fade,
//                     ),
//                     subtitle: Text(
//                       post['message'],
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ))
//                 ..show(context);
//             }
//           }
//         } else {
//           seq = newSeq;
//         }
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   // Configures the actions taken by the app on notification received
//   // Currently not funtional due to the unresponsive mattermost push proxy
//   // void firebaseMessagingInit() async {
//   //   firebaseMessaging.configure(onLaunch: (notification) async {
//   //     print(notification);
//   //   }, onMessage: (notification) async {
//   //     print(notification);
//   //     Flushbar(
//   //       flushbarPosition: FlushbarPosition.TOP,
//   //       backgroundColor: Theme.of(context).primaryColor,
//   //       duration: Duration(seconds: 3),
//   //       messageText: ListTile(
//   //         leading: CircleAvatar(
//   //           child: Icon(Icons.group),
//   //         ),
//   //         title: Text(
//   //           notification['notification']['title'],
//   //           overflow: TextOverflow.ellipsis,
//   //           style: TextStyle(
//   //             color: Colors.white,
//   //           ),
//   //         ),
//   //         subtitle: Text(
//   //           notification['notification']['body'],
//   //           overflow: TextOverflow.ellipsis,
//   //           style: TextStyle(color: Colors.white),
//   //         ),
//   //       ),
//   //     )..show(context);
//   //   }, onResume: (notification) async {
//   //     print(notification);
//   //   });
//   // }

// }
































Map l = {
    "@id": "http://calico.palisadoes.org/@full_content",
    "data": {
        "@id": "http://calico.palisadoes.org/@full_content",
        "@type": "Plone Site",
        "description": "",
        "id": "Quito",
        "is_folderish": true,
        "items": [
            {
                "@id": "http://calico.palisadoes.org/projects",
                "@type": "project_list",
                "description": "A list of all the projects and events for the organisation",
                "review_state": "published",
                "title": "Projects"
            },
            {
                "@id": "http://calico.palisadoes.org/cooking-competition",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/cooking-competition",
                    "@type": "project",
                    "UID": "3d4e772a99494ab3ba8c05a5d8fadc8e",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-07-29T17:02:19+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "A competition for all culinary minded persons who want to make lovely food while having the chance to win a prize",
                    "effective": "2019-07-29T17:02:00",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "cooking-competition",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/cooking-competition/@@images/10e5ac36-e291-49dc-a771-e167ef31beda.jpeg",
                        "filename": "test.jpg",
                        "height": 340,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/54322d9f-2d99-48ae-9296-317c140c06a8.jpeg",
                                "height": 21,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/921b4bd1-84ab-49c2-8492-02d1a6d0ece6.jpeg",
                                "height": 340,
                                "width": 511
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/3210df41-e037-4f26-aff7-7afb2e877f59.jpeg",
                                "height": 10,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/77680c87-ef98-45d5-8082-efe9f6a7fd3a.jpeg",
                                "height": 133,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/0b096b74-2039-4c77-bcf3-7fb0ace82da5.jpeg",
                                "height": 266,
                                "width": 400
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/a4df70cf-5a38-45ac-a7c6-a1170023b966.jpeg",
                                "height": 85,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/cooking-competition/@@images/2fdb9217-2e63-41ed-b46d-4f5686467d18.jpeg",
                                "height": 42,
                                "width": 64
                            }
                        },
                        "size": 47547,
                        "width": 511
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [
                        {
                            "@id": "http://calico.palisadoes.org/cooking-competition/task-upload-by-api",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/cooking-competition/task-upload-by-api",
                                "@type": "task",
                                "UID": "4bdeb4da58954a32867abd3c5229d088",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-07-30T14:43:50+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "the task is to test the api",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "task-upload-by-api",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [],
                                "modified": "2019-07-30T14:43:50+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/cooking-competition",
                                    "@type": "project",
                                    "description": "A competition for all culinary minded persons who want to make lovely food while having the chance to win a prize",
                                    "review_state": "private",
                                    "title": "Cooking Competition"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>Talk to some people to volunteer on the the project</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "Task upload by api",
                                "version": "current"
                            },
                            "description": "the task is to test the api",
                            "review_state": "published",
                            "title": "Task upload by api"
                        },
                        {
                            "@id": "http://calico.palisadoes.org/cooking-competition/fhdhhj",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/cooking-competition/fhdhhj",
                                "@type": "task",
                                "UID": "3daa3637b8dc4cfc8f62a62fc117dab2",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-07-30T14:44:26+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "the task is to test the api",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "fhdhhj",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [],
                                "modified": "2019-07-30T14:44:26+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/cooking-competition",
                                    "@type": "project",
                                    "description": "A competition for all culinary minded persons who want to make lovely food while having the chance to win a prize",
                                    "review_state": "private",
                                    "title": "Cooking Competition"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "zvxjxhxj",
                                    "encoding": "utf8"
                                },
                                "title": "fhdhhj",
                                "version": "current"
                            },
                            "description": "the task is to test the api",
                            "review_state": "published",
                            "title": "fhdhhj"
                        }
                    ],
                    "items_total": 2,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": null,
                    "members": [
                        "jenniferwhite"
                    ],
                    "modified": "2019-08-23T22:41:22+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Cooking Competition",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "A competition for all culinary minded persons who want to make lovely food while having the chance to win a prize",
                "review_state": "private",
                "title": "Cooking Competition"
            },
            {
                "@id": "http://calico.palisadoes.org/movie-night",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/movie-night",
                    "@type": "project",
                    "UID": "7e8e8e3a247342fb858957c268977380",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-07-29T17:10:10+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "A time when people can come together to watch a free movie",
                    "effective": "2019-07-29T17:10:00",
                    "end": "2019-08-01T01:30:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "movie-night",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/movie-night/@@images/b1b005c4-989c-4e42-b266-878d2687f8d7.jpeg",
                        "filename": "download.jpeg",
                        "height": 169,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/c0f1dea9-bbbc-4c14-9917-d7f6a4990bfe.jpeg",
                                "height": 18,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/4eb26653-a9c4-403c-8b2c-3326f882d180.jpeg",
                                "height": 169,
                                "width": 298
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/fd9f3c94-e84d-4305-bb58-3cb4c67fc1ed.jpeg",
                                "height": 9,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/d3d98bca-87c6-453c-9dc2-7bc2ce153e02.jpeg",
                                "height": 113,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/a1eedda2-e03b-49b1-ab2e-407f4b813ed1.jpeg",
                                "height": 169,
                                "width": 298
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/4e47d561-c08f-4e98-8d36-6a354036d2a8.jpeg",
                                "height": 72,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/movie-night/@@images/9c12e443-c07c-4ac6-9a59-c69103b6f3ad.jpeg",
                                "height": 36,
                                "width": 64
                            }
                        },
                        "size": 13340,
                        "width": 298
                    },
                    "image_caption": null,
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": null,
                    "members": [
                        "johnpaul",
                        "jenniferwhite",
                        "bradstewart"
                    ],
                    "modified": "2019-08-22T16:16:53+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-07-31T23:00:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": null,
                    "title": "Movie Night",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "A time when people can come together to watch a free movie",
                "review_state": "private",
                "title": "Movie Night"
            },
            {
                "@id": "http://calico.palisadoes.org/project-by-api-4",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/project-by-api-4",
                    "@type": "project",
                    "UID": "3c36aa74b4924068bc5e19433d306cc6",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-01T00:11:53+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-01T19:29:00",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "project-by-api-4",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/project-by-api-4/@@images/b80dc6a5-c11a-4b16-bd9c-1d4a490d92d9.jpeg",
                        "filename": "test.jpg",
                        "height": 300,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/15146e84-5d7f-4993-b723-9a5d65b23869.jpeg",
                                "height": 32,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/d6299f2c-4ac9-426f-bdfa-f2b4a974951e.jpeg",
                                "height": 300,
                                "width": 300
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/8c73b269-264a-4e99-a17a-b18b3ae3b503.jpeg",
                                "height": 16,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/82e28006-7b6d-4506-957f-dae2bb24936d.jpeg",
                                "height": 200,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/637c5ea6-c3cc-4f2e-b5bd-41f0bf6cb4dc.jpeg",
                                "height": 300,
                                "width": 300
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/86a725b9-d411-4fc9-87d6-a0c6dd53f946.jpeg",
                                "height": 128,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/project-by-api-4/@@images/4b095607-f75c-49f7-9d69-5ad50ccc155f.jpeg",
                                "height": 64,
                                "width": 64
                            }
                        },
                        "size": 11951,
                        "width": 300
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "No location",
                    "members": [
                        "admin",
                        "johnpaul"
                    ],
                    "modified": "2019-08-22T16:15:16+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "clock",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "clock"
            },
            {
                "@id": "http://calico.palisadoes.org/project-by-api-8",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/project-by-api-8",
                    "@type": "project",
                    "UID": "5cdec979b6704c38a61b27ee7dc9f43a",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-01T20:06:32+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-22T16:15:32",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "project-by-api-8",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/project-by-api-8/@@images/1fbf8d1f-0fa1-4201-95c3-de9931346ab8.jpeg",
                        "filename": "test.jpg",
                        "height": 353,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/e780052f-06a8-4b31-b201-05dc6a571fad.jpeg",
                                "height": 32,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/5f3ad439-040f-4c32-8fbe-f5e86c5fcae0.jpeg",
                                "height": 353,
                                "width": 353
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/1be9fb2d-2124-424b-b5d0-872165fd5314.jpeg",
                                "height": 16,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/1f85b0b7-dc7c-42d4-89c9-18e84a6057f1.jpeg",
                                "height": 200,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/88e32270-480f-46b8-a045-33dcba64332d.jpeg",
                                "height": 353,
                                "width": 353
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/9b65598d-13ea-4236-803e-1f94d9d42eff.jpeg",
                                "height": 128,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/project-by-api-8/@@images/f0ef5653-7d42-4637-b3a3-147c9b686320.jpeg",
                                "height": 64,
                                "width": 64
                            }
                        },
                        "size": 26863,
                        "width": 353
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "No location",
                    "members": [
                        "javier",
                        "jenniferwhite",
                        "johnpaul",
                        "admin"
                    ],
                    "modified": "2019-08-22T16:15:36+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Untitled",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "Untitled"
            },
            {
                "@id": "http://calico.palisadoes.org/grand-gala-2019",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/grand-gala-2019",
                    "@type": "project",
                    "UID": "d8f47e0785cc4ae9ad4c40e75b81764a",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": "sombody@email.com",
                    "contact_name": "somebody",
                    "contact_phone": "18761234567",
                    "contributors": [],
                    "created": "2019-08-07T21:03:36+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "a festival that is kept to remember our Independence in Jamaica",
                    "effective": "2019-08-22T16:15:54",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "grand-gala-2019",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/3874877f-4a0a-49c7-8121-d90ccc09e205.jpeg",
                        "filename": "test.jpg",
                        "height": 512,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/fac1715e-aa06-4b69-8d78-89f19189e53e.jpeg",
                                "height": 32,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/f06ba3d9-8db0-45b3-ba74-daae92b99358.jpeg",
                                "height": 512,
                                "width": 512
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/c7794a8e-a871-4e6e-aa24-7f645353f8f4.jpeg",
                                "height": 16,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/9b7619d3-a289-4997-be07-60d3ef245da5.jpeg",
                                "height": 200,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/1a35c353-3755-44a3-9ea0-734f5e08c960.jpeg",
                                "height": 400,
                                "width": 400
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/21e6a200-5c5c-4f97-a8fa-c875075a963e.jpeg",
                                "height": 128,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/grand-gala-2019/@@images/614f91a1-9eb0-42fc-aad6-10c1c38e6952.jpeg",
                                "height": 64,
                                "width": 64
                            }
                        },
                        "size": 48272,
                        "width": 512
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [
                        {
                            "@id": "http://calico.palisadoes.org/grand-gala-2019/get-participants",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/grand-gala-2019/get-participants",
                                "@type": "task",
                                "UID": "636f678f33974559873b7221dd4ecea7",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-08-07T21:04:14+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "get-participants",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [],
                                "modified": "2019-08-07T21:04:14+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/grand-gala-2019",
                                    "@type": "project",
                                    "description": "a festival that is kept to remember our Independence in Jamaica",
                                    "review_state": "private",
                                    "title": "Grand gala 2019"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>Talk to some people to volunteer on the the project</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "get participants",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "get participants"
                        },
                        {
                            "@id": "http://calico.palisadoes.org/grand-gala-2019/get-participants-1",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/grand-gala-2019/get-participants-1",
                                "@type": "task",
                                "UID": "d8db9a4888994968beca5d9c2d710e33",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-08-07T21:04:19+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "get-participants-1",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [],
                                "modified": "2019-08-07T21:04:19+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/grand-gala-2019",
                                    "@type": "project",
                                    "description": "a festival that is kept to remember our Independence in Jamaica",
                                    "review_state": "private",
                                    "title": "Grand gala 2019"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>Talk to some people to volunteer on the the project</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "get participants",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "get participants"
                        }
                    ],
                    "items_total": 2,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "Jamaica",
                    "members": [
                        "admin",
                        "javier",
                        "johnpaul",
                        "jenniferwhite"
                    ],
                    "modified": "2019-08-22T16:15:59+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Grand gala 2019",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": true
                },
                "description": "a festival that is kept to remember our Independence in Jamaica",
                "review_state": "private",
                "title": "Grand gala 2019"
            },
            {
                "@id": "http://calico.palisadoes.org/games-night",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/games-night",
                    "@type": "project",
                    "UID": "95804ed1cc42445086a62696b2b7787e",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-20T23:12:08+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "get together to play games",
                    "effective": "2019-08-22T16:17:33",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "games-night",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/games-night/@@images/90b0fccb-c391-4b96-9ed2-73cc7a929a57.jpeg",
                        "filename": "test.jpg",
                        "height": 512,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/a9837919-27ee-4cb0-b539-c178bfe3fee3.jpeg",
                                "height": 32,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/44d2bf44-184e-48e9-a0a0-31482da45c79.jpeg",
                                "height": 512,
                                "width": 512
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/41b270a0-b1a9-4873-91d9-3d587bafdddc.jpeg",
                                "height": 16,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/c3b353b0-6f82-4e89-81e1-fc1edafc66cb.jpeg",
                                "height": 200,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/f093e844-f703-4abc-b292-f824ad6858ea.jpeg",
                                "height": 400,
                                "width": 400
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/e82d6040-ed0b-4838-8e28-5168b674db37.jpeg",
                                "height": 128,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/games-night/@@images/a9e5bd68-4d3b-47ad-aa94-e798d0d47daf.jpeg",
                                "height": 64,
                                "width": 64
                            }
                        },
                        "size": 40667,
                        "width": 512
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [
                        {
                            "@id": "http://calico.palisadoes.org/games-night/bring-monopoly",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/games-night/bring-monopoly",
                                "@type": "task",
                                "UID": "fbaf8869264b41d6a9743cbc6e1f4c37",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-08-20T23:14:23+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "bring-monopoly",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [
                                    "admin"
                                ],
                                "modified": "2019-08-20T23:14:23+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/games-night",
                                    "@type": "project",
                                    "description": "get together to play games",
                                    "review_state": "private",
                                    "title": "games night"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>None</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "bring monopoly",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "bring monopoly"
                        }
                    ],
                    "items_total": 1,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "No location",
                    "members": [
                        "bradstewart"
                    ],
                    "modified": "2019-08-22T16:17:37+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "games night",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "get together to play games",
                "review_state": "private",
                "title": "games night"
            },
            {
                "@id": "http://calico.palisadoes.org/product-launch",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/product-launch",
                    "@type": "project",
                    "UID": "2cfdae16965e4a8ba6641609ef9fcbcc",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": "anthonio.raphael@gmail.com",
                    "contact_name": "raph",
                    "contact_phone": "8767715500",
                    "contributors": [],
                    "created": "2019-08-21T13:58:28+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "cakes launch for Xmas ",
                    "effective": "2019-08-22T16:17:58",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "product-launch",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": "",
                    "layout": "view",
                    "location": "clf",
                    "members": [],
                    "modified": "2019-08-22T16:18:05+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": "",
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "product launch",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": true
                },
                "description": "cakes launch for Xmas ",
                "review_state": "private",
                "title": "product launch"
            },
            {
                "@id": "http://calico.palisadoes.org/launch",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/launch",
                    "@type": "project",
                    "UID": "022669dcb17f48a597941521557ce9e5",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": "test@test.com",
                    "contact_name": "raph",
                    "contact_phone": "8767715500",
                    "contributors": [],
                    "created": "2019-08-21T14:00:43+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "",
                    "effective": "2019-08-22T16:18:41",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "launch",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [
                        {
                            "@id": "http://calico.palisadoes.org/launch/bake",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/launch/bake",
                                "@type": "task",
                                "UID": "e5f65c11d9b449e48b0d804544dc9783",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": true,
                                "contributors": [],
                                "created": "2019-08-21T14:02:56+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "bake",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [
                                    "admin,test"
                                ],
                                "modified": "2019-08-21T14:05:54+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/launch",
                                    "@type": "project",
                                    "description": "",
                                    "review_state": "private",
                                    "title": "launch"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>None</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "bake",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "bake"
                        },
                        {
                            "@id": "http://calico.palisadoes.org/launch/bake-1",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/launch/bake-1",
                                "@type": "task",
                                "UID": "b02c5f0ecd604c56b162fc042e0ed626",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-08-21T14:03:26+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "bake-1",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [
                                    "admin,test"
                                ],
                                "modified": "2019-08-21T14:03:26+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/launch",
                                    "@type": "project",
                                    "description": "",
                                    "review_state": "private",
                                    "title": "launch"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>make cakes \n\n</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "bake",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "bake"
                        },
                        {
                            "@id": "http://calico.palisadoes.org/launch/run",
                            "@type": "task",
                            "data": {
                                "@id": "http://calico.palisadoes.org/launch/run",
                                "@type": "task",
                                "UID": "c34290e5e00d4864961f61dcf89d732c",
                                "additional_files": null,
                                "allow_discussion": false,
                                "complete": false,
                                "contributors": [],
                                "created": "2019-08-21T14:04:13+00:00",
                                "creators": [
                                    "admin"
                                ],
                                "description": "No description",
                                "effective": null,
                                "expires": null,
                                "extras": null,
                                "id": "run",
                                "is_folderish": true,
                                "items": [],
                                "items_total": 0,
                                "language": "",
                                "layout": "view",
                                "members": [
                                    "admin,test"
                                ],
                                "modified": "2019-08-21T14:04:13+00:00",
                                "nextPreviousEnabled": false,
                                "parent": {
                                    "@id": "http://calico.palisadoes.org/launch",
                                    "@type": "project",
                                    "description": "",
                                    "review_state": "private",
                                    "title": "launch"
                                },
                                "review_state": null,
                                "rights": "",
                                "subjects": [],
                                "task_detail": {
                                    "content-type": "text/html",
                                    "data": "<h2>run errands</h2>",
                                    "encoding": "utf-8"
                                },
                                "title": "run",
                                "version": "current"
                            },
                            "description": "No description",
                            "review_state": "published",
                            "title": "run"
                        }
                    ],
                    "items_total": 3,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "clf",
                    "members": [
                        "admin",
                        "bradstewart"
                    ],
                    "modified": "2019-08-22T16:18:45+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "launch",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": true
                },
                "description": "",
                "review_state": "private",
                "title": "launch"
            },
            {
                "@id": "http://calico.palisadoes.org/vocational-bible-school",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/vocational-bible-school",
                    "@type": "project",
                    "UID": "13e7b83f689c4c948de97f68372bb07d",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-21T21:17:58+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-22T16:19:48",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "vocational-bible-school",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "No location",
                    "members": [
                        "admin",
                        "javier",
                        "jenniferwhite",
                        "johnpaul"
                    ],
                    "modified": "2019-08-22T16:20:01+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Vocational Bible school",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "Vocational Bible school"
            },
            {
                "@id": "http://calico.palisadoes.org/vocational-bible-school-1",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/vocational-bible-school-1",
                    "@type": "project",
                    "UID": "5be5d2a0af4e400384e80fc43e2af15a",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-21T21:21:27+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-22T16:20:52",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "vocational-bible-school-1",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": "No location",
                    "members": [
                        "admin",
                        "javier",
                        "jenniferwhite",
                        "johnpaul"
                    ],
                    "modified": "2019-08-22T16:21:12+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Vocational Bible school",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "Vocational Bible school"
            },
            {
                "@id": "http://calico.palisadoes.org/untitled",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/untitled",
                    "@type": "project",
                    "UID": "c20ada51709741c89082186598bca832",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-21T21:39:43+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-22T16:21:35",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "untitled",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": "",
                    "layout": "view",
                    "location": "No location",
                    "members": [],
                    "modified": "2019-08-22T16:22:01+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": "",
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "Untitled",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "Untitled"
            },
            {
                "@id": "http://calico.palisadoes.org/vbs",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/vbs",
                    "@type": "project",
                    "UID": "b59bb5419f68413a8fe06ce266ef7fee",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-21T21:39:50+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": "2019-08-22T16:22:17",
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "vbs",
                    "image": null,
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": "",
                    "layout": "view",
                    "location": "No location",
                    "members": [],
                    "modified": "2019-08-22T16:22:17+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": "",
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "vbs",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "vbs"
            },
            {
                "@id": "http://calico.palisadoes.org/test-project",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/test-project",
                    "@type": "project",
                    "UID": "f83bbdd81c074225b498e55f973bd161",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-22T16:11:48+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "a test project",
                    "effective": null,
                    "end": "2019-08-22T17:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "test-project",
                    "image": null,
                    "image_caption": null,
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": {
                        "title": "English (USA)",
                        "token": "en-us"
                    },
                    "layout": "view",
                    "location": null,
                    "members": [
                        "phillip"
                    ],
                    "modified": "2019-08-22T16:11:48+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": null,
                    "start": "2019-08-22T16:00:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": null,
                    "title": "Test Project",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "a test project",
                "review_state": "private",
                "title": "Test Project"
            },
            {
                "@id": "http://calico.palisadoes.org/map",
                "@type": "project",
                "data": {
                    "@id": "http://calico.palisadoes.org/map",
                    "@type": "project",
                    "UID": "411dc9404ee24252aa05605e790d7bc4",
                    "allow_discussion": false,
                    "changeNote": "",
                    "contact_email": null,
                    "contact_name": null,
                    "contact_phone": null,
                    "contributors": [],
                    "created": "2019-08-23T20:22:16+00:00",
                    "creators": [
                        "admin"
                    ],
                    "description": "No description",
                    "effective": null,
                    "end": "2020-06-17T19:00:00+00:00",
                    "event_url": null,
                    "exclude_from_nav": false,
                    "expires": null,
                    "extras": null,
                    "id": "map",
                    "image": {
                        "content-type": "image/jpeg",
                        "download": "http://calico.palisadoes.org/map/@@images/47739d05-1bca-4756-8e3b-ff364ca9a0bb.jpeg",
                        "filename": "test.jpg",
                        "height": 504,
                        "scales": {
                            "icon": {
                                "download": "http://calico.palisadoes.org/map/@@images/ee577082-5178-4ed6-9fa6-a8294af5f050.jpeg",
                                "height": 32,
                                "width": 32
                            },
                            "large": {
                                "download": "http://calico.palisadoes.org/map/@@images/c5c51b10-1420-4048-ab73-d8da7e625e40.jpeg",
                                "height": 504,
                                "width": 504
                            },
                            "listing": {
                                "download": "http://calico.palisadoes.org/map/@@images/f1d9b61e-97ad-453b-be6b-212aeeb25b52.jpeg",
                                "height": 16,
                                "width": 16
                            },
                            "mini": {
                                "download": "http://calico.palisadoes.org/map/@@images/adc3f2ab-ea6f-48b8-9dfd-cd531fed489d.jpeg",
                                "height": 200,
                                "width": 200
                            },
                            "preview": {
                                "download": "http://calico.palisadoes.org/map/@@images/82694e6b-6751-40e1-91b6-4e8939aa18b9.jpeg",
                                "height": 400,
                                "width": 400
                            },
                            "thumb": {
                                "download": "http://calico.palisadoes.org/map/@@images/209c241d-9888-479d-ab90-daef5ce9e08e.jpeg",
                                "height": 128,
                                "width": 128
                            },
                            "tile": {
                                "download": "http://calico.palisadoes.org/map/@@images/3cb91e1c-0dd4-405c-90eb-6075dd88bd5f.jpeg",
                                "height": 64,
                                "width": 64
                            }
                        },
                        "size": 41708,
                        "width": 504
                    },
                    "image_caption": "Image captions",
                    "is_folderish": true,
                    "items": [],
                    "items_total": 0,
                    "language": "",
                    "layout": "view",
                    "location": "No location",
                    "members": [],
                    "modified": "2019-08-23T20:22:16+00:00",
                    "open_end": false,
                    "parent": {
                        "@id": "http://calico.palisadoes.org",
                        "@type": "Plone Site",
                        "description": "",
                        "title": "Core"
                    },
                    "recurrence": null,
                    "review_state": "private",
                    "rights": "",
                    "start": "2019-06-12T17:20:00+00:00",
                    "subjects": [],
                    "sync_uid": null,
                    "text": {
                        "content-type": "text/html",
                        "data": "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
                        "encoding": "utf-8"
                    },
                    "title": "map",
                    "version": "current",
                    "versioning_enabled": true,
                    "whole_day": false
                },
                "description": "No description",
                "review_state": "private",
                "title": "map"
            }
        ],
        "items_total": 15,
        "parent": {},
        "tiles": {},
        "tiles_layout": {},
        "title": "Core"
    }
}
;