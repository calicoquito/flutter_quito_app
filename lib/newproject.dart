import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'addmembers.dart';

class NewProject extends StatefulWidget{

  NewProjectState createState() => NewProjectState();

}

class NewProjectState extends State<NewProject>{
  TextEditingController controller = TextEditingController();
  String textString = "";
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Project',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20.0),
        )
      ),
      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Event Name',
                textAlign: TextAlign.left,
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: TextField(
                autocorrect: true,
                controller: controller,
                decoration: InputDecoration(
                  labelText:"Enter Here...",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder()
                  ),
                onChanged: (string){
                  setState(() {
                    textString = string;
                  });
                },
                onEditingComplete: (){
                  controller.clear();
                },
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
        color: Colors.lightBlue,
        splashColor: Colors.blue,
        textColor: Colors.white70,
        child: Text('Next'),
        onPressed: (){
          print(textString);
          controller.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context){return AddMembersPage();}));
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