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

    try {
      for (String username in usernames) {
        for (Map<dynamic, dynamic> userinfo in users) {
          if (username == userinfo["username"]) {
            matchingusers.add(userinfo);
          }
        }
      }
    } catch (err) {
      print('no users found');
    }
    return matchingusers;
  }
}
