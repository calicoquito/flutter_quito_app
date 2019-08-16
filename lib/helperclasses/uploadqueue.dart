import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/helperclasses/saver.dart';
import 'package:quito_1/helperclasses/urls.dart';
//import 'package:flutter_uploader/flutter_uploader.dart';
import 'user.dart';
import 'dart:async';
import 'dart:io';

enum uploadtype {
  addproject,
  editproject,
  addtask,
  edittask,
  delete,
}

class UploadQueue {
  static User user;

  static Future<bool> connection() async {
    try {
      final result = await InternetAddress.lookup(Urls.main);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static add(uploadtype type, String url, Map json) async {
    List upload = [url, json];
    List uploadlist = await Saver.getData(name: "uploadlist");
    if (uploadlist == null) {
      uploadlist = [
        [url, json]
      ];
    } else if (!uploadlist.contains(upload)) {
      uploadlist.add(upload);
    }
    print(uploadlist);
    Saver.setData(name: "uploadlist", data: uploadlist);
  }

  static upload() async {
    bool uploaded;
    try {
      var response;
      List uploadlist = await Saver.getData(name: "uploadlist");
      if (uploadlist != null) {
        for (var i in uploadlist) {
          uploadtype type = i[0];
          String url = i[1];
          Map json = i[2];
          if (type == uploadtype.addproject) {
            response = await NetManager.uploadProject(url, json);
          } else if (type == uploadtype.addtask) {
            response = await NetManager.uploadTask(url, json);
          } else if (type == uploadtype.editproject) {
            response = await NetManager.editProject(url, json);
          }
          if (response == 204) {
            uploadlist.remove([url, json]);
            uploaded = true;
          }
        }
      }
    } catch (err) {
      uploaded = false;
    }
    return uploaded;
  }


//  static uploader() async {
//    final taskId = await uploader.enqueue(
//        url: "your upload link", //required: url to upload to
////        files: [FileItem(filename: filename, savedDir: savedDir, fieldname:"file")], // required: list of files that you want to upload
//        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
//        headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
//        data: {"name": "john"}, // any data you want to send in upload request
//        showNotification: false, // send local notification (android only) for upload status
//        tag: "upload 1"); // unique tag for upload task
//    );
//  }

  static Future<String> uploadAll() async {
    print('yo yo');
    bool connected = await connection();
    var uploaded;
    if (connected == true) {
      uploaded = await upload();
    }

    List uploadlist = await Saver.getData(name: "uploadlist");
    if (uploadlist == null) {
      uploadlist = [];
    }

    if (uploadlist.isEmpty && uploadlist.isEmpty && uploaded == true) {
      print("uploaded");
      return "uploaded";
    }
    print("${uploadlist.length} failed");
    return "failed";
  }
}
