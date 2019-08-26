import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:quito_1/helperclasses/uploadqueue.dart';
import 'dart:convert';
import 'saver.dart';
import 'user.dart';
import 'urls.dart';
import 'dart:io';

class NetManager {
  static User user;
  static Map projects = Map();
  static Map<String, dynamic> channels = Map();
  static Map<String, dynamic> channelsByName = Map();

  static getProjects() async {
    String url = Urls.fullcontet;
    List data = List();
    try {
      var resp = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });
      var respBody = json.decode(resp.body);
      data = respBody["data"]["items"];
    } catch (err) {
      print(err);
    }
    data.removeWhere((item) => item["@type"] != "project");
    return data;
  }

  static getTasks(String projecturl) async {
    List projectlist = List();
    projectlist = await getProjects();
    projectlist =
        projectlist.where((item) => item["@id"] == projecturl).toList();
    return projectlist[0]["data"]["items"] == null
        ? []
        : projectlist[0]["data"]["items"];
  }

  static Future<List> getProjectsData() async {
    String url = Urls.projects;
    List data = List();
    List filterProjects = List();
    Map projectsData = Map();
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });

      var resBody = json.decode(response.body);
      data = resBody["items"];
      for (var i in data) {
        i = i as Map;
      }

      Future getimglink(int i) async {
        try {
          var resp = await http.get(data[i]["@id"], headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${user.ploneToken}'
          });
          var respBody = json.decode(resp.body);
          if (respBody != null && respBody["image"] != null) {
            String imageLink = respBody["image"]["scales"]["large"]["download"];
            if (respBody['members'].contains(user.username)) {
              data[i].putIfAbsent('id', () => respBody['id']);
              data[i].putIfAbsent('thumbnail', () => imageLink);
              filterProjects.add(data[i]);
              projectsData.putIfAbsent(respBody['id'], () => data[i]);
            }
            return imageLink;
          } else {
            return null;
          }
        } catch (err) {
          print('***********GET IMAGE LINK************');
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
      data = filterProjects; //data;
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

  // static Future getLargeImage(int index, String url) async {
  //   try {
  //     var resp = await http.get(url, headers: {
  //       "Accept": "application/json",
  //       "Authorization": 'Bearer ${user.ploneToken}'
  //     });
  //     var respBody = json.decode(resp.body);
  //     if (respBody != null) {
  //       String imageLink = respBody["image"]["scales"]["large"]["download"];
  //       return imageLink;
  //     }
  //   } catch (err) {
  //     print('********GET LARGE IMAGE***********');
  //     print(err);
  //   }
  // }

  static Future getProjectEditData(String url) async {
    Map data = Map();
    List assignedMembers = List();
    File file;
    var resp = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${user.ploneToken}",
    });
    print(resp.statusCode);
    data = json.decode(resp.body);
    print(data["mambers"]);
    if (data["members"] != null) {
      assignedMembers = data["members"].isEmpty ? null : data["members"];
    }
    if (data['image'] != null) {
      file = await DefaultCacheManager()
          .getSingleFile(data['image']['download'], headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${user.ploneToken}'
      });
    }

    return {"data": data, "file": file, "assignedMembers": assignedMembers};
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
      data = resBody["items"];
      for (var i = 0; i == data.length; i++) {
        setval.add(false);
      }
    } catch (err) {
      print(err);
      //data is empty so get saved data when try block fails
      data = await Saver.getData(name: "$url-tasksdata");
      data = data;
      for (var i in data) {
        setval.add(false);
      }
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
    print(response.body);
    if (response.statusCode != 204) {}
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

  static Future<int> editTaskComplete(String url, bool value) async {
    Map json = {
      "complete": value,
    };
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
      if (resp.statusCode == 204) {
        return resp.statusCode;
      }
    } catch (err) {
      print(err);
    }
    return resp.statusCode;
  }

// Gets the Mattermost channels which will be used to create each chat
  static Future<Map> getChannels() async {
    try {
      List teamEndpoints = user.teams.map((team) {
        return 'http://mattermost.alteroo.com/api/v4/users/${user.userId}/teams/${team['id']}/channels';
      }).toList();

      List<Future> requests = teamEndpoints.map((endpoint) {
        try {
          return http.get(endpoint,
              headers: {'Authorization': 'Bearer ${user.mattermostToken}'});
        } catch (err) {
          print(err);
        }
      }).toList();

      final responses = await Future.wait(requests).catchError((err) {
        print('Error awaiting all responses');
      });
      responses.forEach((resp) {
        final json = jsonDecode(resp.body);
        final channelsList = json.where((channel) {
          bool isMember = projects.keys.toList().contains(channel['name']);
          return isMember;
        }).toList();
        channelsList.forEach((channel) {
          channels.putIfAbsent(channel['id'], () => channel);
          channelsByName.putIfAbsent(channel['name'], () => channel);
        });
      });
    } catch (err) {
      print(err);
    }
    return channels;
  }
}
