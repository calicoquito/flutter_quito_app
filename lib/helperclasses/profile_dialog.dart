import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user.dart';

class ProfileDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height*0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              Icons.person,
              color:Colors.blue,
              size: 50.0
            ),
            Text(
              user.username,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue
              ),
            )
          ],
        ),
      ),
    );
  }
}