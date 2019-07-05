import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'helperclasses/message.dart';
import 'helperclasses/user.dart';

/*
 * This screen defines how the chats will appear when 
 * opened and how they will be animated and managed
 */

// All print statements are temporary and for debugging purposes

class OpenChatScreen extends StatefulWidget{
  final String title;
  final User user;
  final User recipient;

  @override
  OpenChatScreen({Key key, this.title, this.user, this.recipient}):super(key:key);

  @override
  OpenChatScreenState createState() => OpenChatScreenState(); 
}

class OpenChatScreenState extends State<OpenChatScreen>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final firestore = Firestore.instance;
  DocumentReference senderChatDocumentReference;
  DocumentReference receiverChatDocumentReference;
  StreamSubscription chatStream;

  List<Widget> messages =[
  ];

  void handleSend() async {
    print('Sent ${controller.text}');
    if(controller.text.isNotEmpty){
      final senderChatDocument = await senderChatDocumentReference.get();
      try{
        await senderChatDocument.reference.updateData({
          'messages':[
            ...senderChatDocument.data['messages'],
            {
              'type': 'outgoing',
              'body': controller.text
            }
          ]
        });
        final receiverChatDocument = await receiverChatDocumentReference.get();
        await receiverChatDocument.reference.updateData({
          'messages':[
            ...receiverChatDocument.data['messages'],
            {
              'type': 'incoming',
              'body': controller.text
            }
          ]
        });
        setState(() {
          messages.add(OutgoingMessage(message: controller.text,));
          controller.clear();
        });
        //scrolls to the last message received
        Timer(Duration(milliseconds: 100),(){scrollController.jumpTo(scrollController.position.maxScrollExtent);});
      }
      catch(err){
        print(err);
      }
    }
  }

  @override
  void initState(){
    super.initState();
    senderChatDocumentReference = firestore.document('/users/${widget.user.userID}/contacts/${widget.recipient.userID}');
    receiverChatDocumentReference = firestore.document('/users/${widget.recipient.userID}/contacts/${widget.user.userID}');
    chatStream = senderChatDocumentReference.snapshots().listen((snapshot){
      try{
        if(snapshot['messages'].length-1>0 && snapshot['messages'][snapshot['messages'].length-1]['type']=='incoming'){
          setState(() {
            messages.add(IncomingMessage(message: snapshot['messages'][snapshot['messages'].length-1]['body']));
          });
          //scrolls to the last message received
          Timer(Duration(milliseconds: 100),(){scrollController.jumpTo(scrollController.position.maxScrollExtent);});
        }
      }
      catch(err){
        print(err);
      }
    });
  }

  @override
  void dispose(){
    chatStream.cancel();
    senderChatDocumentReference.updateData({'messages':[]});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details){
        if(details.velocity.pixelsPerSecond.dx>0)
          Navigator.of(context).pop();
      },
      child: Scaffold(
        //Appbar at the top of the page
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
            PopupMenuButton(
              onSelected: (item){
                print('item was selected');
              },
              itemBuilder: (context){
                return <PopupMenuItem>[
                  PopupMenuItem(
                    child: Text('Settings'),
                  ),
                  PopupMenuItem(
                    child: Text('Log out'),
                  )
                ];
              },
            )
          ],
        ),

        //Contents of the page
        body: Stack(
          children: <Widget>[
            //This is the area where the chat messages will be displayed
            Positioned(
              top: 0.0,
              bottom: MediaQuery.of(context).size.height*0.09,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.09,
                child: messages.length==0?
                Center(child: Text('No messages'),)
                :ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index){
                    return messages[index];
                  },
                ),
              ),
            ),

            //This is the bar at the bottom of the page where text is written to be sent
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
                          controller: controller,
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

                    //This button sends the message
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.send),
                      onPressed: handleSend
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
