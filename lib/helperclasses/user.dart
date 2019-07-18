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
  String _token;
  String _userID;

  User({String username, String password, String token, String userID}){
    this._username = username;
    this._password = password;
    this._token = token;
    this._userID = userID;
  }

  String get username => _username;
  String get password => _password;
  String get token => _token;
  String get userID => _userID;

  set username(String username){
    this._username = username;
  }
  set password(String password){
    this._password = password;
  }
  set token(String token){
    this._token = token;
  }
  set userID(String userID){
    this._userID = userID;
  }
}