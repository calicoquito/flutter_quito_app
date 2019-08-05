import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quito_1/helperclasses/netmanager.dart';

import 'helperclasses/urls.dart';
import 'helperclasses/user.dart';
import 'userinfo.dart';

class AddMembersPage extends StatefulWidget {
  final User user;
  AddMembersPage({this.user});
  AddMembersPageState createState() => AddMembersPageState(user: user);
}

class AddMembersPageState extends State<AddMembersPage>
    with SingleTickerProviderStateMixin {
  final User user;
  AddMembersPageState({this.user});
  TabController controller;

  final String url = Urls.users;
  List data = List();
  List<bool> setval = List();
  List selectusers = List();
  List selectgorups;
  List newdata = List();

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    getData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int count = 1;
  List holder = List();
  void setsearchdata() {
    if (count == 1){
      holder = data;
    }
    setState(() {
      data = newdata;
    });
    count+=1;
  }

  void addtolist() {
    for (int i = 0; i < setval.length; i++) {
      if (setval[i] == true) {
        Map user = data[i];
        selectusers.add(user);
      }
    }
    Navigator.pop(context, selectusers);
  }

  Future<String> getData() async {
    data = await NetManager.getUsersData();
    setState(() {
      data = data;
    });
      for (var i = 0; i < data.length; i++) {
        setval.add(false);
      }
    return "Success!";
  }

  Widget lst(List data) {
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                    onTap: ()=> Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserInfo(userinfo: data[index]);
                      })),
                    trailing: Checkbox(
                      value: setval[index],
                      onChanged: (bool value) {
                        if (data.length < holder.length){
                          data = holder;
                        }
                        setState(() {
                          setval[index] = value;
                        });
                      },
                    ),
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: data[index]["portrait"] == null ? AssetImage('assets/images/default-image.jpg') : NetworkImage(data[index]["portrait"]),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text("${data[index]["fullname"]}"),
                    subtitle: Text("Email: ${data[index]["email"]}",
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.black54)),
                  ),
                  Divider(
                    height: 1.0,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add team'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20.0, bottom: 40.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: "Search a group or member name",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder()),
                onChanged: (text) {
                  if (data.length<holder.length){
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
              )),
          Container(
            height: 70.0,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: TabBar(
              controller: controller,
              tabs: [
                Tab(
                  icon: const Icon(Icons.person_add),
                  text: 'People',
                ),
                Tab(
                  icon: const Icon(Icons.group_add),
                  text: 'Groups',
                ),
              ],
            ),
          ),
          Container(
            height: 320.0,
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                Container(child: lst(data)), 
                Container()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          addtolist();
        },
      ),
    );
  }
}
