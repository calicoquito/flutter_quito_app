import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sidedrawer.dart';
import 'helperclasses/user.dart';

//MonaConnect IP Address 172.16.236.24
//Owner IP Address 192.168.137.137

/*
 * This widget describes how the page which will allow an admin
 * to add a specific person or specific group of persons  to a new
 * project will look. 
 */
class AddMembersPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Hero(
        tag: 'navdrawer',
        child: SideDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          'Add Members',
          style: TextStyle(
            fontSize: 20.0
          )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              Navigator.of(context).popUntil(ModalRoute.withName('/home'));
            },
          )
        ],
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
              child: MembersTabView(),
            )
          ],
        ),
      ),
    );
  }
}


class MembersTabView extends StatefulWidget {
  MembersTabViewState createState() => MembersTabViewState();
}

class MembersTabViewState extends State<MembersTabView> with SingleTickerProviderStateMixin{
  List<ListView> views = List<ListView>();
  List contacts;
  List groups;
  
  TabController controller;

  void fetchContacts() async {
    try {
      var resp = await http.get("http://192.168.137.1:8080/contacts", headers:{"Accept":"application/json"});
      setState(() {
        contacts = jsonDecode(resp.body);
      }); 
    }
    catch(err){
      print('Error fetching contacts');
    }
  }

  void fetchGroups() async {
    try{
      var resp = await http.get('http://192.168.137.1:8080/groups', headers: {"Accept":"application/json"});
      setState(() {
        groups = jsonDecode(resp.body);
      });
    }
    catch(err){
      print('Error fetching groups');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, initialIndex: 0, length: 2);
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
      //backgroundColor: Color(0xff00306f),
      backgroundColor: Colors.white,
      appBar: TabBar(
        controller: controller,
        indicator: BoxDecoration(color: Colors.amber),
        labelPadding: EdgeInsets.all(0.0),
        indicatorPadding: EdgeInsets.all(0.0),
        unselectedLabelColor: Colors.black54,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.person_add)),
            Tab(icon: Icon(Icons.group_add))
          ],
        ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          contacts==null ? 
          Scaffold(body:Center(child: CircularProgressIndicator())) :
          ContactPage(contacts: contacts),
          groups==null ? 
          Scaffold(body:Center(child: CircularProgressIndicator())):
          GroupPage(groups: groups)
        ]
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
    return ListTile(
      onTap: onchange,
      leading: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0),
        child: widget.image,
        //backgroundImage: ,   To be figured out 
      ),
      title: Text(widget.title),
      trailing: Checkbox(
        value: state,
        onChanged: change,
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
    return ListTile(
      onTap: onchange,
      leading: Icon(Icons.group),
      title: Text(widget.title),
      trailing: Checkbox(
        value: state,
        onChanged: change,
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  ContactPage({this.contacts});

  final List contacts;
  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> with AutomaticKeepAliveClientMixin<ContactPage>{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    return ListView.builder(
      itemCount: widget.contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactItem(title: widget.contacts[index]["name"]??'Loading...');
      }
    );
  }
}


class GroupPage extends StatefulWidget {
  GroupPage({this.groups});

  final List groups;
  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> with AutomaticKeepAliveClientMixin<GroupPage>{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    return ListView.builder(
      itemCount: widget.groups.length,
      itemBuilder: (BuildContext context, int index) {
        return GroupItem(title: widget.groups[index]["groupName"]??'Loading...');
      }
    );
  }
}