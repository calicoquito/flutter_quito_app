import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quito_1/membersview.dart';
import 'dart:convert';
import 'eventsinfo.dart';
import 'eventsinfoedit.dart';
import 'tasks.dart';
import 'dart:async';

class EventList extends StatefulWidget {
  EventListState createState() => EventListState();
}

class EventListState extends State<EventList> {
  final String url = "http://192.168.100.68:8080/Plone/projects";
  List data;
  Widget appBarTitle = Text('Events');
  Icon actionIcon = Icon(Icons.search);
  List newdata = List();

  int count = 1;
  List holder = List();
  void setsearchdata() {
    if (count == 1) {
      holder = data;
    }
    setState(() {
      data = newdata;
    });
    count += 1;
  }

  @override
  void initState() {
    super.initState();
    getSWData();
  }

  Future getSWData() async {
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    data = resBody["items"];
    for (var i in data) {
      i = i as Map;
    }

    Future<String> getimglink(int i) async {
      try {
        var resp = await http
            .get(data[i]["@id"], headers: {"Accept": "application/json"});
        print(resp.statusCode);
        var respBody = json.decode(resp.body);
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
    setState(() {
      data = data;
    });
    return "Success!";
  }

  Future delete(int index) async {
    String url = data[index]["@id"];
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var resp = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Basic $credentials"
      },
    );
    print(resp.statusCode);
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
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
                            : NetworkImage(data[index]["image"]),
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Members(
                                              url: data[index]["@id"]);
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

    return Scaffold(
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
                appBarTitle = Text('Events');
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
            return EventsInfo();
          }));
        },
      ),
    );
  }
}
