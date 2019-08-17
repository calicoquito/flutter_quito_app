import 'package:quito_1/helperclasses/netmanager.dart';

class UsersManager {
  static var users;
  // usersManager(){
  //   getusers();
  // }

  // getusers() async {
  //   users = await NetManager.getUsersData();
  // }

  static Future<List<Map>> getmatchingusers(List usernames) async {
    List users = await NetManager.getUsersData();
    List<Map> matchingusers = List();
    try {
      for (String username in usernames) {
        for (Map userinfo in users) {
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
