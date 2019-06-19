import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quito_1/sidedrawer.dart';
import 'addmembers.dart';
import 'helperclasses/user.dart';

class NewProject extends StatefulWidget{
  NewProject({Key key, this.user}):super(key:key);
  final User user;

  @override
  NewProjectState createState() => NewProjectState();
}

class NewProjectState extends State<NewProject>{
  TextEditingController controller;
  String textString = "";
  
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Hero(
        tag: 'navdrawer',
        child: SideDrawer(user:widget.user,)
      ),
      appBar: AppBar(
        title: Text(
          'New Project',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20.0
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.widgets),
            onPressed: (){
              SnackBar(
                content: Text('Snack Time'),
                duration: Duration(seconds: 3),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Project Name',
                textAlign: TextAlign.left,
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: TextField(
                autocorrect: true,
                controller: controller,
                decoration: InputDecoration(
                  labelText:"Project name",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()
                  ),
                onChanged: (string){
                  setState(() {
                    textString = string;
                  });
                }
              ),
            ),
            Padding(
              padding:EdgeInsets.symmetric(vertical: 20.0)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Checklist',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12.0),
                  )
                ),
                CheckItem(itemName: "Registration"),
                CheckItem(itemName: "Book Location"),
                CheckItem(itemName: 'Budget'),
                CheckItem(itemName: 'Notification')
              ],
            )
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FlatButton(
        shape: StadiumBorder(),
        color: Colors.lightBlue,
        splashColor: Colors.blue,
        textColor: Colors.white70,
        child: Text('Next', style: TextStyle(color: Colors.black),),
        onPressed: (){
          controller.clear();
          Navigator.of(context).push(MaterialPageRoute(
            maintainState: true,
            builder: (context){return AddMembersPage(user: widget.user,);}));
        },
      ),
    );
  }
}


//This class implements the Checkbox paired with the Text widget to make it easily reusable
class CheckItem extends StatefulWidget{
  CheckItem({Key key, this.itemName}): super(key:key);

  final String itemName;

  State createState()=> CheckItemState();
}

class CheckItemState extends State<CheckItem>{
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
    return Card(
      margin: EdgeInsets.all(1.0),
      child: RawMaterialButton(
        onPressed: onchange,
        splashColor: Colors.amberAccent,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: state,
              onChanged: change
            ),
            Text(
                this.widget.itemName,
                textAlign: TextAlign.start,
            )
          ],
        )
      )
    );
  }
}