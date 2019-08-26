import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quito_1/openchatscreen.dart';
import 'package:quito_1/taskedit.dart';
import 'helperclasses/dialogmanager.dart';
import 'helperclasses/netmanager.dart';
import 'helperclasses/user.dart';
import 'taskcreate.dart';
import 'taskdata.dart';

class TaskList extends StatefulWidget {
  final User user;
  final String projecturl;
  final String projectName;
  const TaskList(this.user, this.projecturl, {this.projectName});
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
  bool isLoading = true;

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
    isLoading = true;
    getSWData();
  }

  Future getSWData() async {
    data = await NetManager.getTasks(projecturl);
    print('********TASKS.DART GETSWDATA************');
    for (var task in data) {
      switchlist.add(task["data"]["complete"]);
    }
    try {
      if (this.mounted) {
        setState(() {
          data = data;
          switchlist = switchlist;
          isLoading = false;
        });
      }
    } catch (err) {
      print('*********TASKS.DART GETSWDATA*********');
      print(err);
    }
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
                          clipBehavior: Clip.hardEdge,
                          elevation: 6.0,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, right: 10.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                color: switchlist[index] == true
                                    ? Colors.green[700] 
                                    : Colors.red,
                                width: 6.0,
                              ))),
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
                                        child: FlatButton(
                                          onPressed: () {},
                                          color: Color(0xff7e1946),
                                          //Colors.primaries[Random().nextInt(15)],
                                          shape: StadiumBorder(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "${data[index]["data"]["members"].where((member) => member != 'admin').toList().length}",
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
                                          if (data[index]["data"]["complete"] ==
                                              false) {
                                            await DialogManager.complete(
                                                context,
                                                "Are You Sure You Want mark this task as complete?");
                                            if (DialogManager.answer == true) {
                                              data[index]["data"]["complete"] =
                                                  true;
                                              await NetManager.editTask(
                                                  data[index]["@id"],
                                                  data[index]["data"]);
                                            }
                                            getSWData();
                                            if (this.mounted) {
                                              setState(() {
                                                switchlist[index] = true;
                                              });
                                            }
                                          } else {
                                            await DialogManager.okay(context,
                                                "This Task Is Already Finished");
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
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
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Taskedit(data[index]["@id"], user, projecturl);
                    })).then((value)=> getSWData());
                    await data[index]["data"]["complete"] ;
                    setState(() {
                      switchlist = switchlist;
                    });
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    await DialogManager.delete(
                        context, "Are You Sure You Want to delete this task?");
                    if (DialogManager.answer == true) {
                      delete(index);
                    }
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
          IconButton(
            icon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return OpenChatScreen(
                    title: user.channelsByName[widget.projectName]
                            ['display_name'] ??
                        'Untitled',
                    user: user,
                    channelId: user.channelsByName[widget.projectName]['id'],
                    project: user.projects[widget.projectName]);
              }));
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await getSWData();
          },
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: data.isEmpty
                      ? Center(
                          child: Text(
                          'No Tasks Yet',
                          style: TextStyle(fontSize: 16),
                        ))
                      : lst(Icon(Icons.person), data))),
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
