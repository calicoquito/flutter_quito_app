import 'package:flutter/material.dart';
import 'package:quito_1/chatscreen.dart';
import 'package:quito_1/openscreen.dart';

import 'helperclasses/user.dart';

class HomePages extends StatefulWidget{
  final User user;

  const HomePages({Key key, this.user}) : super(key: key);
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  PageController controller = PageController(keepPage: true, );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: <Widget>[
          OpenScreen(user: widget.user,),
          ChatScreen(user: widget.user,)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        onTap: (index){
          setState(() {
           controller.animateToPage(
             index,
             duration: Duration(seconds: 1),
             curve: Curves.easeOut
            ); 
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work,),
            title: Text('Projects',)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chats'),
          )
        ],
      ),
    );
  }
}