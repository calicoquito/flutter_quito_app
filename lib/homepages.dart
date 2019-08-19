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
    return PageView(
      controller: controller,
      children: <Widget>[
        OpenScreen(user: widget.user,),
        ChatScreen(user: widget.user,)
      ],
    );
  }
}