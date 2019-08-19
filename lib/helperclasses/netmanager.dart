import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:quito_1/helperclasses/uploadqueue.dart';
import 'dart:convert';
import 'saver.dart';
import 'user.dart';
import 'urls.dart';

class NetManager {
  static User user;

  static Future<List> getProjectsData() async {
    //print('Bearer ${user.ploneToken}');
    String url = Urls.projects;
    List data = List();
    Map projects = Map();

    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });

      var resBody = json.decode(response.body);
      print(response.statusCode);
      data = resBody["items"];
      for (var i in data) {
        i = i as Map;
      }

      List filterProjects = List();
      Map projectsData = Map();
      Future getimglink(int i) async {
        try {
          var resp = await http.get(data[i]["@id"], headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${user.ploneToken}'
          });
          var respBody = json.decode(resp.body);
          if (respBody != null) {
            String imageLink = respBody["image"]["scales"]["thumb"]["download"];
            if (respBody['members'].contains(user.username)) {
              data[i].putIfAbsent('id', () => respBody['id']);
              data[i].putIfAbsent('thumbnail', () => imageLink);
              filterProjects.add(data[i]);
              projectsData.putIfAbsent(respBody['id'], () => data[i]);
            }
            return imageLink;
          }
        } catch (err) {
          print(err);
        }
      }

      for (var i = 0; i < data.length; i++) {
        var imgs = await getimglink(i);
        if (imgs != null) {
          data[i] = data[i];
          data[i]['image'] = imgs;
        }
      }

      // set data state and save json for online use when this try block works
      data = data; //filterProjects;
      Saver.setData(data: data, name: "projectsdata");
      projects = projectsData;

      return data;
    } catch (err) {
      print(err);
      //data is empty so get saved data when try block fails
      data = await Saver.getData(name: "projectsdata");
    }
    return data;
  }

  static Future getLargeImage(int index, String url)async{

        try {
          var resp = await http.get(url, headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${user.ploneToken}'
          });
          var respBody = json.decode(resp.body);
          if (respBody != null) {
            String imageLink = respBody["image"]["scales"]["large"]["download"];
            return imageLink;
          }
        } catch (err) {
          print(err);
        }
      
  }



  static Future getProjectEditData(String url) async {
    Map data = Map();
    List assignedMembers = List();
    var file;
    var resp = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${user.ploneToken}",
    });
    print(resp.statusCode);
    data = json.decode(resp.body);
    if (data["contributors"] != null) {
      assignedMembers = data["contributors"].isEmpty
          ? null
          : json.decode(data["contributors"][0]);
    }
    if (data['image'] != null) {
      file =
          await DefaultCacheManager().getSingleFile(data['image']['download']);
    }

    return {"data": data, "file": file, "assignedMembers": assignedMembers};
  }



  static Future<List> getUsersData() async {
    List  data = List();
    List<bool> setval = List();
    String url = Urls.users;
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });
      var resBody = json.decode(response.body);

      data = resBody;

      for (var i = 0; i == data.length; i++) {
        setval.add(false);
      }
    } catch (err) {
      print(err);
      data = [];
    }
    if (data == null) {
      data = [];
    }
    return data;
  }

  static Future<List> getTasksData(String url) async {
    List data = List();
    List<bool> setval = List();

    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${user.ploneToken}",
      });
      var resBody = json.decode(response.body);
      // print(user.ploneToken);
      // print(resBody['items']);
      data = resBody["items"];
      // print(data);
      for (var i = 0; i == data.length; i++) {
        setval.add(false);
      }
    } catch (err) {
      print(err);
      //data is empty so get saved data when try block fails
      data = await Saver.getData(name: "$url-tasksdata");
      data = data;
      for (var i = 0; i == data.length; i++) {
        setval.add(false);
      }
      print(data);
      return data;
    }
    return data;
  }

  static Future<Map> getTask(String url) async {
    Map data;
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${user.ploneToken}",
      });
      var resBody = json.decode(response.body);
      print(resBody);

      data = resBody;
    } catch (err) {
      print(err);
      data = {};
    }
    return data;
  }


  
  static Future<int> uploadProject(String url, Map json) async {
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(json));
    print(response.statusCode);
    if (response.statusCode != 204) {
      
    }
    return response.statusCode;
  }

  static Future<int> editProject(String url, Map json) async {
    var response = await http.patch(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(json));
    print(response.statusCode);
        if (response.statusCode != 201) {
      UploadQueue.add(uploadtype.editproject, url, json);
    }
    return response.statusCode;
  }

  static Future<int> uploadTask(String url, Map json) async {
    print(json);
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(json));
    print(response.statusCode);
    if (response.statusCode != 201) {
      UploadQueue.add(uploadtype.addtask, url, json);
    }
    return response.statusCode;
  }

  static Future<int> editTask(String url, Map json) async {
    print(json);
    var response = await http.patch(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(json));
    print(response.statusCode);
    if (response.statusCode != 201) {
      UploadQueue.add(uploadtype.edittask, url, json);
    }
    return response.statusCode;
  }

  static Future<int> delete(String url) async {
    var resp;
    try {
       resp = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${user.ploneToken}'
        },
      );
      print(resp.statusCode);
      print(resp.body);
      if (resp.statusCode == 204) {
        return resp.statusCode;
      }
    } catch (err) {
      print(err);
    }
    return resp.statusCode;
  }
}
