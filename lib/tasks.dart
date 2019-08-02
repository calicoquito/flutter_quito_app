import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'helperclasses/saver.dart';
import 'helperclasses/user.dart';
import 'task.dart';
import 'taskdata.dart';
import 'dart:math';

class TaskList extends StatefulWidget {
  final String url;
  final User user;
  const TaskList({@required this.url, this.user});
  @override
  TaskListState createState() => TaskListState(url: url, user: user);
}

class TaskListState extends State<TaskList> {
  final String url;
  final User user;
  TaskListState({@required this.url, this.user});
  List data = List();
  List<bool> setval = List();
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

  Future<String> getSWData() async {
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${widget.user.ploneToken}",
      });
      var resBody = json.decode(response.body);
      print(widget.user.ploneToken);
      print(resBody['items']);
      setState(() {
        data = resBody["items"];
        Saver.setData(data: data, name: "tasksdata");
        print(data);
        for (var i in data) {
          setval.add(false);
          // if (data[i]['additiional_files'] == null) {
          //   data[i]['additiional_files'] = Random().nextInt(15);
          // }
        }
      });
    } catch (err) {
      print(err);
      //data is empty so get saved data when try block fails
      
      setState(() async {
        data = await Saver.getData(name: "tasksdata");
      });
      print(data);
      return "Success!";
    }
    //data is empty so get saved data when try block fails
    data = await Saver.getData(name: "tasksdata");
    setState(() {
      data = data;
    });
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
                      Divider(
                        height: 10.0,
                      ),
                      Card(
                        child: ListTile(
                            contentPadding:
                                EdgeInsets.only(top: 4.0, left: 4.0),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TaskData(url: url, user: widget.user);
                              }));
                            },
                            leading: CircleAvatar(
                              child: Text(
                                  "${data[index]["title"].split('')[0]}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              radius: 48.0,
                              backgroundColor:
                                  // data[index]['additiional_files'] == null ?
                                  // Colors.primaries[data[index]['additiional_files']]  :
                                  Colors.primaries[Random().nextInt(15)],
                            ),
                            title: Text("Task Name: ${data[index]["title"]}"),
                            subtitle: Text(
                                "Task Data: To do ${data[index]["description"]} ",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.black54)),
                            trailing: Checkbox(
                                value: setval[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    setval[index] = value;
                                  });
                                })),
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
                  //onTap: () => _showSnackBar('Archive'),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    data.removeAt(index);
                    //delete(index);
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
            return Task(url: url, user: widget.user);
          }));
        },
      ),
    );
  }
}
