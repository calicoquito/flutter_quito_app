
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class Saver {
  static Future<dynamic> getData({name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.getString(name) == null
        ? null
        : json.decode(prefs.getString(name));
    return data;
  }

  static Future setData({name: String, data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringdata = json.encode(data);
    prefs.setString(name, stringdata);
    return "Success!";
  }

  static Future<bool> getSignInState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedIn')??false;
  }

  static Future setSignInState(bool state)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSignedIn', state);
  }

  static Future<File> getImage({name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    File data = prefs.getString(name) == null
        ? null
        : json.decode(prefs.getString(name));
    return data;
  }

  static Future setImage({url: String, name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var file = await DefaultCacheManager().getSingleFile(url);
    if (file != null) {
      var base64Image = base64Encode(file.readAsBytesSync());
      String data = base64Image;
      String stringdata = json.encode(data);
      prefs.setString(name, stringdata);
    }
    return "Success!";
  }
}
