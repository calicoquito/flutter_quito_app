import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:quito_1/profile_dialog.dart';
import 'chatscreen.dart';
import 'helperclasses/user.dart';
// import 'projectscreen.dart';
import 'settings.dart';

class SideDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final User user = Provider.of<User>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context, 
                  builder: (context)=>ProfileDialog()
                );
              },
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                  foregroundColor: Colors.white,
                ),
                accountEmail: Text(user.email),
                accountName: Text(user.username),
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Chat"),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=> ChatScreen(user:Provider.of<User>(context))
                  )
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.work),
            //   title: Text('Projects'),
            //   onTap: (){
            //     Navigator.of(context).pop();
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context)=>Projects()
            //       )
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=>Settings()
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: ()async{
                await user.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route)=>false);
              },
            )
          ]
        )
      ),
    );
  }
}
