import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/helperclasses/saver.dart';

class UploadQueue {
  static addtask(String url, Map json) async {
    List taskupload = [url, json];
    List taskuploadlist = await Saver.getData(name: "taskuploadlist");
    if (taskuploadlist == null) {
      taskuploadlist = [
        [url, json]
      ];
    } else {
      taskuploadlist.add(taskupload);
    }
    Saver.setData(name: "taskuploadlist", data: taskuploadlist);
  }

  static uploadtasks() async {
    List taskuploadlist = await Saver.getData(name: "taskuploadlist");
    if (taskuploadlist == null) {
      for (var i in taskuploadlist) {
        String url = i[0];
        Map json = i[1];
        var response = await NetManager.uploadTask(url, json);
        if (response == 204) {
          removetask(url, json);
        }
      }
    }
  }

  static removetask(String url, Map json) async {
    List taskupload = [url, json];
    List taskuploadlist = await Saver.getData(name: "taskuploadlist");
    for (var i in taskuploadlist) {
      if (i == taskupload) {
        taskuploadlist.remove(i);
      }
    }
    Saver.setData(name: "taskuploadlist", data: taskuploadlist);
  }

  static addproject(String url, Map json) async {
    List projectupload = [url, json];
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    if (projectuploadlist == null) {
      projectuploadlist = [
        [url, json]
      ];
    } else {
      projectuploadlist.add(projectupload);
    }
    Saver.setData(name: "projectuploadlist", data: projectuploadlist);
  }

  static uploadprojects() async {
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    if (projectuploadlist == null) {
      for (var i in projectuploadlist) {
        String url = i[0];
        Map json = i[1];
        var response = await NetManager.uploadProject(url, json);
        if (response == 204) {
          removeproject(url, json);
        }
      }
    }
  }

  static removeproject(String url, Map json) async {
    List projectupload = [url, json];
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    for (var i in projectuploadlist) {
      if (i == projectupload) {
        projectuploadlist.remove(i);
      }
    }
    Saver.setData(name: "projectuploadlist", data: projectuploadlist);
  }

  static Future<bool> uploadAll() async {
    uploadprojects();
    uploadtasks();
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    List taskuploadlist = await Saver.getData(name: "taskuploadlist");

    if (projectuploadlist.isEmpty && taskuploadlist.isEmpty) {
      return true;
    }
    return false;
  }
}
