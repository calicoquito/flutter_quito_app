import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quito_1/helperclasses/netmanager.dart';
import 'helperclasses/saver.dart';
import 'openscreen.dart';
import 'signinscreen.dart';
import 'helperclasses/user.dart';

class Router extends StatefulWidget {
  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getSignInStatus();
  }

  void getSignInStatus() {
    Saver.getSignInState().then((state) {
      setState(() {
        isSignedIn = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (isSignedIn == true) {
      NetManager.user = user;
      print('Bearer ${user.ploneToken}');
      return OpenScreen(
        user: user,
      );
    } else {
      return SignInScreen();
    }
  }
}
