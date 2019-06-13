import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMembersPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Members',
          style: TextStyle(
            fontSize: 20.0
          )
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Search')
            ),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child:TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Enter a group or member name",
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder()
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.all(20.0)
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: 400.0,
                maxWidth: MediaQuery.of(context).size.width
              ),
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

class MembersTabBarState extends State<MembersTabBar> with SingleTickerProviderStateMixin{

  TabController controller;
  ListView contactsList;
  ListView groupsList;

  void fetchContacts(){
    http.get("http://192.168.137.137:3000/contacts", 
    headers:{"Accept":"application/json"})
    .then((resp){
      setState(() {
        List contacts = jsonDecode(resp.body);
        contactsList = ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ContactItem(title: contacts[index]["name"], image:Image.network(contacts[0]["image"]))
                  ],
                ),
              ),
            );
          }
        );
      });
    });
  }

  void fetchGroups(){
    http.get('http://192.168.137.137:3000/groups', 
    headers: {"Accept":"application/json"})
    .then((resp){
      setState(() {
        List groups = jsonDecode(resp.body);
        groupsList = ListView.builder(
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GroupItem(title: groups[index]["groupName"])
                  ],
                ),
              ),
            );
          }
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    fetchContacts();
    fetchGroups();
  }


 @override
 void dispose() {
   controller.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TabBar(
        indicator: BoxDecoration(color: Colors.amber),
        labelPadding: EdgeInsets.all(0.0),
        indicatorPadding: EdgeInsets.all(0.0),
        indicatorColor: Colors.orange,
        unselectedLabelColor: Colors.black54,
          controller: controller,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.group_add)),
            Tab(icon: Icon(Icons.person_add))
          ],
        ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Center(child: groupsList),
          Center(child: contactsList)
        ],
      ),
    );
  }
}



// Custom class designed to manage each individual contact
class ContactItem extends StatefulWidget{
  ContactItem({Key key, this.title, this.image:const Icon(Icons.person)}) : super(key:key);

  final String title;
  final Widget image;

  @override
  ContactItemState createState() => ContactItemState();
}

class ContactItemState extends State<ContactItem>{

  bool state=false; 

  void change(bool newValue){
    setState(() {
      state = !state;
    });
  }
  void onchange(){
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context){
    return RawMaterialButton(
      onPressed: onchange,
      splashColor: Colors.amber,
      child:ListTile(
        leading: CircleAvatar(
          child: widget.image,
          //backgroundImage: ,   To be figured out 
        ),
        title: Text(widget.title),
        trailing: Checkbox(
          value: state,
          onChanged: change,
        )
      )
    );
  }
}

class GroupItem extends StatefulWidget{
  GroupItem({Key key, this.title});

  final String title;

  @override
  GroupItemState createState() => GroupItemState();
}

class GroupItemState extends State<GroupItem>{

  bool state=false; 

  void change(bool newValue){
    setState(() {
      state = !state;
    });
  }
  void onchange(){
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context){
    return RawMaterialButton(
      onPressed: onchange,
      splashColor: Colors.amber,
      child: ListTile(
        leading: Icon(Icons.group),
        title: Text(widget.title),
        trailing: Checkbox(
          value: state,
          onChanged: change,
        ),
      ),
    );
  }
}