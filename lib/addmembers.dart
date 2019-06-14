import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddMembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Add Members', style: TextStyle(fontSize: 20.0))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8.0), child: Text('Search')),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText: "Enter a group or member name",
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder()),
                )),
            Padding(padding: EdgeInsets.all(20.0)),
            Container(
              constraints: BoxConstraints(
                  maxHeight: 400.0,
                  maxWidth: MediaQuery.of(context).size.width),
              child: MembersTabBar(),
            )
          ],
        ),
      ),
    );
  }
}

class MembersTabBar extends StatefulWidget {
  MembersTabBarState createState() => MembersTabBarState();
}

class MembersTabBarState extends State<MembersTabBar>
    with SingleTickerProviderStateMixin {
  TabController controller;

  final String url = "https://randomuser.me/api/?results=500";
  List data;
  List<bool> setval = List();

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

  Future<String> getSWData() async {
    var response = await http.get(url, headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(response.body);
      data = resBody["results"];
      for (var i in data) {
        setval.add(false);
      }
    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0,left: 4.0),
                      onTap: () {},
                      trailing: Checkbox(
                        value: setval[index],
                        onChanged: (bool value) {
                          setState(() {
                            setval[index] = value;
                          });
                        },
                      ),
                      leading: CircleAvatar(
                        radius:28.0,
                        backgroundImage:
                            NetworkImage(data[index]["picture"]["thumbnail"]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                          "Name: ${data[index]["name"]["first"]} ${data[index]["name"]["last"]}"),
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

    return Scaffold(
      appBar: TabBar(
        indicator: BoxDecoration(color: Colors.blue),
        labelPadding: EdgeInsets.all(0.0),
        indicatorPadding: EdgeInsets.all(0.0),
        indicatorColor: Colors.orange,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        controller: controller,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.group_add,)),
          Tab(icon: Icon(Icons.person_add,))
        ],),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Container(child: lst(Icon(Icons.group),data)),
          Container(child: lst(Icon(Icons.person), 
          data != null? data.reversed.toList(): data)),
        ],
      ),
    );
  }
}
