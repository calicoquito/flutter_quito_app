import 'package:flutter/material.dart';

class Message extends StatefulWidget{
  final String username;
  final String message;
  @override
  Message({Key key, this.message, this.username}):super(key:key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message>{
  Color color;
  double elevation;
  bool isPressed=false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        if(!isPressed){
          setState(() {
            isPressed=true;
            color= Colors.blueAccent[100].withOpacity(0.5);
            elevation=0.0;
          });
        }
      },
      onTap: (){
        if(isPressed){
          setState(() {
            isPressed =false;
            color=Theme.of(context).scaffoldBackgroundColor;
            elevation=1.0;
          });
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*0.9),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 8),
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                widget.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16  ,
                  color: Theme.of(context).primaryColor
                ),
                softWrap: true,
              ),
              subtitle: Text(
                widget.message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
