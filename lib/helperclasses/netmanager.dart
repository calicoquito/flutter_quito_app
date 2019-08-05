import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'saver.dart';
import 'user.dart';
import 'urls.dart';

class NetManager {
  static User user;

  static Future<List> getProjectsData() async {
    print('Bearer ${user.ploneToken}');
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
      data = data;//filterProjects;
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

  static Future<int> uploadProject(String url, Map projectsjson) async {
    var resp = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(projectsjson));
    print(resp.statusCode);
    print(resp.body);
    return resp.statusCode;
  }

  static Future deleteProject(int index, List data) async {
    String url = data[index]["@id"];
    try {
      var resp = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${user.ploneToken}'
        },
      );
      print(resp.statusCode);
      if (resp.statusCode == 204){
      return data;
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<List> getUsersData() async {
    List data = List();
    List<bool> setval = List();
    String url = Urls.users;
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });
      print(response.statusCode);
      print(response.body);
      var resBody = json.decode(response.body);
      print(resBody);
      data = resBody;
      print("hey hey hey $data");
      for (var i = 0; i == data.length; i++) {
        setval.add(false);
      }
    } catch (err) {
      print(err);
      data = [];
    }
    if (data == null){
      data = [];
    }
    return data;
  }

  static Future getTasksData(String url) async {
    List data = List();
    List<bool> setval = List();

    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${user.ploneToken}",
      });
      var resBody = json.decode(response.body);
      print(user.ploneToken);
      print(resBody['items']);
      data = resBody["items"];
      Saver.setData(data: data, name: "$url-tasksdata");
      print(data);
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
  }

  static Future<Map> getTask(String url, Map data) async {
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

  static Future<int> uploadTask(String url, Map data) async {
    var response;
    try {
      response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${user.ploneToken}",
      });
      return response.statusCode;
    } catch (err) {}
    return response.statuscode == null ? 400 : response.statuscode;
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
    if (data["contributors"] != null){
    assignedMembers = data["contributors"].isEmpty ? null 
    : json.decode(data["contributors"][0]);}
    if (data['image']!= null){
    file = await DefaultCacheManager().getSingleFile(data['image']['download']);
    }

    return {"data": data, "file" : file,"assignedMembers" : assignedMembers};
  }

  static Future<int> editProject(String url, Map json) async {
    var resp = await http.patch(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.ploneToken}",
        },
        body: jsonEncode(json));
    print(resp.statusCode);
    return resp.statusCode;
  }

}
