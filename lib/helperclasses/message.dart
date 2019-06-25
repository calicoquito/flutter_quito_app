import 'package:flutter/material.dart';

abstract class Message extends StatefulWidget{
  final String message;

  Message({Key key, this.message}):super(key:key);

}

class OutgoingMessage extends Message{
  @override
  OutgoingMessage({Key key, String message}):super(key:key, message:message);

  @override
  OutgoingMessageState createState() => OutgoingMessageState();
}

class OutgoingMessageState extends State<OutgoingMessage>{
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
            color= Colors.blueAccent[100];
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: color,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*0.5),
                  child: Card(
                    color: color,
                    elevation: elevation,
                    child: Text(widget.message)
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

class IncomingMessage extends Message{
  @override
  IncomingMessage({Key key, String message}):super(key:key, message:message);

  @override
  IncomingMessageState createState() => IncomingMessageState();
}

class IncomingMessageState extends State<IncomingMessage>{
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
            color= Colors.blueAccent[100];
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: color,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*0.5),
                  child: Card(
                    color: color,
                    elevation: elevation, 
                    child: Text(widget.message)
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