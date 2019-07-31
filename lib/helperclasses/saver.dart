import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Saver {

  Future getData({name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //print(prefs.getString('stringdata'));
    var data = prefs.getString(name) == null
        ? null
        : json.decode(prefs.getString(name));

    return data;
  }

  Future setData({name: String, data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringdata = json.encode(data);
    prefs.setString(name, stringdata);

    return "Success!";
  }



  Future<File> getImage({name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    File data = prefs.getString(name) == null
        ? null
        : json.decode(prefs.getString(name));

    return data;
  }

  Future setImage({url: String, name: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var file = await DefaultCacheManager().getSingleFile(url);
    if (file != null){
      var base64Image =  base64Encode(file.readAsBytesSync());
      String data = base64Image;
      String stringdata = json.encode(data);
      prefs.setString(name, stringdata);
    }
    return "Success!";
  }


}
