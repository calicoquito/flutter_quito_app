/*
 * This is used to pass the user's
 * information down the widget tree as the user 
 * traverses the app
 */

import 'package:quito_1/helperclasses/saver.dart';

class User {
  String username;
  String password;
  String ploneToken;
  String mattermostToken;
  String userId;
  String email;
  Map projects;
  Map<String, String> members;
  List<Map<String, String>> teams;


  static final User _user = User._internal();

  factory User() => _user;

  User._internal() {
    email = 'null';
    username = 'null';
    password = 'null';
    ploneToken = 'null';
    mattermostToken = 'null';
    userId = 'null';
    members = Map();
    projects = Map();
    teams = List();
  }



  static save(){
    Saver.setData(name: 'email', data: User._internal().email);
    Saver.setData(name: 'username', data: User._internal().username);
    Saver.setData(name: 'password', data: User._internal().password);
    Saver.setData(name: 'ploneToken', data: User._internal().ploneToken);
    Saver.setData(name: 'mattermostToken', data: User._internal().mattermostToken);
    Saver.setData(name: 'userId', data: User._internal().userId);
    Saver.setData(name: 'members', data: User._internal().members);
    Saver.setData(name: 'projects', data: User._internal().projects);
    Saver.setData(name: 'teams', data: User._internal().teams);
  }

  static retrieve()async {
    User._internal().email = await Saver.getData(name: 'email');
    User._internal().username = await Saver.getData(name: 'username');
    User._internal().password = await Saver.getData(name: 'password');
    User._internal().ploneToken = await Saver.getData(name: 'ploneToken');
    User._internal().mattermostToken = await Saver.getData(name: 'mattermostToken');
    User._internal().userId = await Saver.getData(name: 'userId');
    User._internal().members = await Saver.getData(name: 'members');
    User._internal().projects = await Saver.getData(name: 'projects');
    User._internal().teams = await Saver.getData(name: 'teams');
  }
}
