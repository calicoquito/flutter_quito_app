import 'package:flutter/cupertino.dart';

/*
 * This InheritedWidget is used to pass the user's
 * information down the widget tree as the user 
 * traverses the app
 */

class InheritedUser extends InheritedWidget{
  final User user;
  InheritedUser({Widget child, this.user}): super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedUser of(BuildContext context)=> 
    context.inheritFromWidgetOfExactType(InheritedUser);
}

class User{
  String _username;
  String _password;

  User(String username, String password){
    this._username = username;
    this._password = password;
  }

  String get username => _username;
  String get password => _password;

  set username(String username){
    this._username = username;
  }
  set password (String password){
    this._password = password;
  }
}