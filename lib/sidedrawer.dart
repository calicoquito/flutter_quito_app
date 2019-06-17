import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.4,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            DrawerHeader(child: Icon(Icons.person),),
            ListTile(
              title: Text('Projects'),
              onTap: (){
                print('Projects');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: (){
                print('Logout');
              },
            )
          ]
        )
      ),
    );
  }
}