import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'userinfo.dart';

class AddMembersPage extends StatefulWidget {
  AddMembersPageState createState() => AddMembersPageState();
}

class AddMembersPageState extends State<AddMembersPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  final String url = "http://192.168.100.68:8080/Plone/@users";
  List data;
  List<bool> setval = List();
  List select_users = List();
  List select_gorups;
  List newdata = List();

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    getSWData();
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
        select_users.add(user);
      }
    }
    Navigator.pop(context, select_users);
  }

  Future<String> getSWData() async {
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    });

    setState(() {
      var resBody = json.decode(response.body);
      data = resBody;
      for (var i in data) {
        setval.add(false);
      }
    });

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
                        return User(user: data[index]);
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
                      backgroundImage: NetworkImage(data[index]["portrait"]),
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
