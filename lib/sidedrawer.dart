import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget{
  SideDrawer({Key key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.4,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Icon(Icons.person),
              accountEmail: Text('test@gmail.com'),
              accountName: Text('test'),
            ),
            ListTile(
              title: Text('Projects'),
              onTap: (){
                print('Projects');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            )
          ]
        )
      ),
    );
  }
}