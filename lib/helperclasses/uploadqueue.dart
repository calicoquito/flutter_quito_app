import 'package:quito_1/helperclasses/netmanager.dart';
import 'package:quito_1/helperclasses/saver.dart';

enum uploadtype {
  addproject,
  editproject,
  addtask,
  edittask,
  delete,
}

class UploadQueue {

  static add(uploadtype type, String url, Map json) async {
    List upload = [url, json];
    List uploadlist = await Saver.getData(name: "uploadlist");
    if (uploadlist == null) {
      uploadlist = [
        [url, json]
      ];
    } else if (!uploadlist.contains(upload)){
      uploadlist.add(upload);
    }
    Saver.setData(name: "uploadlist", data: uploadlist);
  }

  static upload() async {
    var response;
    List uploadlist = await Saver.getData(name: "uploadlist");
    if (uploadlist != null) {
      for (var i in uploadlist) {
        uploadtype type = i[0];
        String url = i[1];
        Map json = i[2];
        if (type == uploadtype.addproject){
          response = await NetManager.uploadProject(url, json);
        }else if (type == uploadtype.addtask){
          response = await NetManager.uploadTask(url, json);
        }else if (type == uploadtype.editproject){
          response = await NetManager.editProject(url, json);
        }
        if (response == 204) {
          uploadlist.remove([url, json]);
        }
      }
    }
  }


  static Future<String> uploadAll() async {
    upload();
    List projectuploadlist = await Saver.getData(name: "projectuploadlist");
    List uploadlist = await Saver.getData(name: "uploadlist");

    if (projectuploadlist.isEmpty && uploadlist.isEmpty) {
      return "uploaded";
    }
    return "failed";
  }
}
