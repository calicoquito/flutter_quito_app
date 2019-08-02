import 'package:flutter/material.dart';

class Message extends StatefulWidget{
  final String username;
  final String message;
  final String type;
  @override
  Message({Key key, this.message, this.username, this.type}):super(key:key);

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
            color=Colors.transparent;
            elevation=1.0;
          });
        }
      },
      child: Material(
        color: color,
        child: Align(
          alignment: widget.type == 'incoming' ? Alignment.centerLeft : Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*0.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: color,
                child: ListTile(
                  title:  widget.type == 'incoming' ?
                   Text(
                    widget.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16  ,
                      color: Theme.of(context).primaryColor
                    ),
                    softWrap: true,
                  ) : null,
                  subtitle: Text(
                    widget.message,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
