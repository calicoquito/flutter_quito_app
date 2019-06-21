import 'package:flutter/material.dart';

class OpenChatScreen extends StatefulWidget{
  final String title;

  @override
  OpenChatScreen({Key key, this.title}):super(key:key);

  @override
  OpenChatScreenState createState() => OpenChatScreenState(); 
}

class OpenChatScreenState extends State<OpenChatScreen>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details){
        print(details.globalPosition.direction);
        Navigator.of(context).pop();
      },
      onHorizontalDragEnd: (details){
        print(details.velocity.pixelsPerSecond.direction);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          titleSpacing: 0.0,
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.person),
              ),
              SizedBox(width: 5.0,),
              Text(widget.title)
            ],
          ),
          actions: <Widget>[
            Icon(Icons.more_vert)
          ],
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              height: MediaQuery.of(context).size.height*0.91,
              child: Column(
                children: <Widget>[
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.09,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffeeeeee),
                  border: Border(
                    top: BorderSide(width: 0.2),
                    bottom: BorderSide(width: 0.2),
                    left:BorderSide(width: 0.2),
                    right: BorderSide(width: 0.2)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      tooltip: "Add stuff",
                      icon:Icon(Icons.add),
                      onPressed: (){},
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          expands: true,
                          maxLines: null,
                          autocorrect: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            hasFloatingPlaceholder: false,
                            labelText: "Type..."
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.camera_alt),
                      onPressed: (){},
                    ),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.send),
                      onPressed: (){},
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}