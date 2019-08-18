import 'package:flutter/material.dart';

class Message extends StatefulWidget{
  final String username; // the sender of the message 
  final String message; // the text content of the message
  final String type; // the type of message, incoming or outgoing
  @override
  Message({Key key, this.message, this.username, this.type}):super(key:key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message>{
  Color color; //  the color of the widget to indicate being selected or not
  double elevation; // the elevation of the widget material
  bool isPressed=false; 

  @override
  void initState(){
    super.initState();
    color = Scaffold.of(context).widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        if(!isPressed){
          setState(() {
            isPressed=true;
            color = Colors.blue[300];
            elevation=0.0;
          });
        }
      },
      onTap: (){
        if(isPressed){
          setState(() {
            isPressed =false;
            color= Scaffold.of(context).widget.backgroundColor;
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
            child: Card(
              color: widget.type =='incoming' ? Colors.blue : Colors.green,
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.type == 'incoming' 
                ?Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor
                      ),
                      softWrap: true,
                    ),
                    Text(
                      'widget.messagejkb;kadb;kbdaaibiuviuvjhjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjviuvkviuvuivijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                  ],
                )
                :Text(
                  widget.message,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
