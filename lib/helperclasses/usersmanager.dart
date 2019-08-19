import 'package:quito_1/helperclasses/netmanager.dart';

class UsersManager {
  static var users;


  static Future<List> getmatchingusers(List usernames) async {
    try {
      if (usernames[0].toString().contains(',')) {
        usernames = usernames[0].split(',');
      }
    }catch(err){
      usernames = [];
    }

    List users = await NetManager.getUsersData();
    List matchingusers = List();
    //print(usernames[1]);jenniferwhite   jenniferwhite

    try {
      for (String username in usernames) {
        for (Map<dynamic, dynamic> userinfo in users) {
          // print(username.compareTo(userinfo["username"]) == 0);
          // print('$username   ${userinfo["username"]}');
          if (username == userinfo["username"]) {
            matchingusers.add(userinfo);
          }
        }
      }
    } catch (err) {
      print('no users found');
    }
    // print("matchingusers");
    // print(matchingusers);
    return matchingusers;
  }
}
