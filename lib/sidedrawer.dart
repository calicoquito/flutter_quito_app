import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'helperclasses/user.dart';

class SideDrawer extends StatelessWidget{
  SideDrawer({Key key, this.user}): super(key:key);
  final User user;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            GestureDetector(
              onTap: (){
                showDialog(context: context, 
                  builder: (context)=>Dialog(
                    backgroundColor: Color(0xff003366),
                    child:Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color:Colors.white,
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
                    )
                  )
                );
              },
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                  foregroundColor: Colors.white,
                ),
                accountEmail: Text('test@gmail.com'),
                accountName: Text(user.username),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.work),
                title: Text('Projects'),
                onTap: (){
                  Navigator.of(context).pop();
                  showDialog(context: context,  
                    builder: (context)=>Dialog(
                      backgroundColor: Color(0xff003366),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.filter_none,size: 50.0,color: Colors.white,),
                          Text(
                            'No Projects Available',
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.orangeAccent
                            )
                          )
                        ],
                      ),
                    )
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.of(context).pop();
                showDialog(context: context,  
                  builder: (context)=>Dialog(
                    backgroundColor: Color(0xff003366),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.build,size: 50.0,),
                        Text(
                          'Under Construction',
                           style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.blue
                           )
                        )
                      ],
                    ),
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
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