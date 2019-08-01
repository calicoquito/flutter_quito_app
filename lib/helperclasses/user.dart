/*
 * This is used to pass the user's
 * information down the widget tree as the user 
 * traverses the app
 */

class User{
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

  User._internal(){
    email ='null';
    username = 'null';
    password = 'null';
    ploneToken= 'null';
    mattermostToken = 'null';
    userId = 'null';
    members = Map();
    projects = Map();
    teams = List();
  }
}