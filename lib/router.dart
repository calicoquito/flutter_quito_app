import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/helperclasses/uploadqueue.dart';
import 'package:quito_1/homepages.dart';
import 'helperclasses/saver.dart';
import 'openscreen.dart';
import 'signinscreen.dart';
import 'helperclasses/user.dart';



/// This [StatefulWidget] is used to navigate the user to the 
/// appropriate opening page as it is used to decide if the user
/// is logged in or not. If logged in, the user will be sent to
/// the home screen[OpenScreen] and if not, the user will be sent to the 
/// sign in screen[SignInScreen]
///
///

class Router extends StatefulWidget{

  @override
  RouterState createState() => RouterState();
}

class RouterState extends State<Router> {
  bool isSignedIn = false;


  void getSignInStatus(){
    Saver.getSignInState()
    .then((state){
      setState(() {
       isSignedIn = state;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getSignInStatus();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (isSignedIn == true) {
      UploadQueue.uploadAll();
      NetManager.user = user;
      return HomePages(
        user: user,
      );
    } else {
      return SignInScreen();
    }
  }
}
