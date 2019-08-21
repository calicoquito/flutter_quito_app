import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quito_1/taskedit.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'task.dart';
import 'taskdata.dart';
import 'dart:math';

class TaskList extends StatefulWidget {
  final User user;
  final String projecturl;
  const TaskList(this.user, this.projecturl);
  @override
  TaskListState createState() => TaskListState(user, projecturl);
}

class TaskListState extends State<TaskList> {
  final String projecturl;
  final User user;
  TaskListState(this.user, this.projecturl);
  List data = List();
  List<bool> switchlist = List();
  Widget appBarTitle = Text('Tasks');
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
    data = await NetManager.getTasksData(projecturl);
    print(data);
    for (var task in data) {
      var taskinfo = await NetManager.getTask(task['@id']);
      print(taskinfo["complete"]);
      print(task);
      switchlist.add(taskinfo["complete"] == true ? true : false);
      // if (data[i]['additiional_files'] == null) {
      //   data[i]['additiional_files'] = Random().nextInt(15);
      // }
    }
    setState(() {
      data = data;
      switchlist = switchlist;
    });
  }

  Future delete(int index) async {
    var response = await NetManager.delete(data[index]["@id"]);
    if (response == 204) {
      data.removeAt(index);
      getSWData().whenComplete(() {
        setState(() {
          data = data;
        });
      });
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
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TaskData(
                                url: data[index]["@id"], user: widget.user);
                          }));
                        },
                        child: Card(
                          elevation: 6.0,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(" ${data[index]["title"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w800)),
                                      Container(
                                        width: 70,
                                        child: RaisedButton(
                                          onPressed: () {},
                                          color: 
                                          //Color(0xff7e1946),
                                          Colors.primaries[Random().nextInt(15)],
                                          shape: StadiumBorder(),
                                          child: Row(
                                            mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "${Random().nextInt(4) + 1}",
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                        "${data[index]["description"]} ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54)),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                        child: Text(
                                          "Done",
                                          style: TextStyle(
                                              color: Colors.blue[900],
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        onPressed: () async {
                                          Map task = await NetManager.getTask(
                                              data[index]["@id"]);
                                          print(task);
                                          task["complete"] = !task["complete"];
                                          await NetManager.editTask(
                                              data[index]["@id"], task);
                                        }),
                                  ),
                                ],
                              )),
                        ),
                      )

                      // Card(
                      //     child: Container(
                      //   height: 100.0,
                      //   child: ListTile(
                      //     contentPadding: EdgeInsets.all(10),
                      //     onTap: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (context) {
                      //         return TaskData(
                      //             url: data[index]["@id"], user: widget.user);
                      //       }));
                      //     },
                      //     // leading: CircleAvatar(
                      //     //   child: Text("${data[index]["title"].split('')[0]}",
                      //     //       style: TextStyle(
                      //     //           color: Colors.white, fontSize: 20)),
                      //     //   radius: 48.0,
                      //     //   backgroundColor:
                      //     //       // data[index]['additiional_files'] == null ?
                      //     //       // Colors.primaries[data[index]['additiional_files']]  :
                      //     //       Colors.primaries[Random().nextInt(15)],
                      //     // ),

                      //     title: Text(" ${data[index]["title"]}",
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(
                      //             fontSize: 18.0,
                      //             color: Colors.grey[800],
                      //             fontWeight: FontWeight.w800)),
                      //     subtitle: Text("${data[index]["description"]} ",
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(
                      //             fontSize: 15.0, color: Colors.black54)),
                      //     trailing: Container(
                      //       child: Switch(
                      //           value: switchlist[index],
                      //           onChanged: (value) async {
                      //             Map task = await NetManager.getTask(
                      //                 data[index]["@id"]);
                      //             print(task);
                      //             task["complete"] = value;
                      //             await NetManager.editTask(
                      //                 data[index]["@id"], task);
                      //             setState(() {
                      //               switchlist[index] = value;
                      //             });
                      //           }),
                      //     ),
                      //   ),
                      // )),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Taskedit(data[index]["@id"], user, projecturl);
                    }));
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
      appBar: AppBar(
        title: appBarTitle,
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
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (text) {
                      if (data.length < holder.length) {
                        data = holder;
                      }
                      text = text.toLowerCase();
                      setState(() {
                        newdata = data.where((user) {
                          var name = user["fullname"].toLowerCase();
                          return name.contains(text);
                        }).toList();
                      });
                      setsearchdata();
                    },
                  );
                } else {
                  actionIcon = Icon(Icons.search);
                  appBarTitle = Text('Tasks');
                }
              });
            },
          ),
        ],
      ),
      body: Container(child: lst(Icon(Icons.person), data)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Task(widget.user, projecturl);
          }));
        },
      ),
    );
  }
}
