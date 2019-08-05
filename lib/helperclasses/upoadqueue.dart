import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/helperclasses/saver.dart';

class UpouadQueue {
  
  addtask(String url, Map json) async {
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

  uploadtasks() async {
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

  removetask(String url, Map json) async {
    List taskupload = [url, json];
    List taskuploadlist = await Saver.getData(name: "taskuploadlist");
    for (var i in taskuploadlist) {
      if (i == taskupload) {
        taskuploadlist.remove(i);
      }
    }
    Saver.setData(name: "taskuploadlist", data: taskuploadlist);
  }

  addproject(String url, Map json) async {
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

  uploadprojects() async {
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

  removeproject(String url, Map json) async {
    List projectupload = [url, json];
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    for (var i in projectuploadlist) {
      if (i == projectupload) {
        projectuploadlist.remove(i);
      }
    }
    Saver.setData(name: "projectuploadlist", data: projectuploadlist);
  }
}
