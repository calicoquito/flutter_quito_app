import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';



class ImgManager{

  static Future<File> optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Take a photo'),
                        Icon(Icons.camera)
                      ],
                    ),
                    onTap: () async{
                       File img = await  openimg(ImageSource.camera, context);
                       return img;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Select from gallery'),
                        Icon(Icons.image)
                      ],
                    ),
                    onTap: () async{
                      File img = await openimg(ImageSource.gallery, context);
                      return img;
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  static Future openimg(ImageSource source, BuildContext context) async {
    var file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      cropImage(file, context);
    }
    return file;
  }


  static Future cropImage(File imageFile, BuildContext context) async {
    File croppedFile = await ImageCropper.cropImage(
      toolbarColor: Color(0xff7e1946),
      statusBarColor: Colors.blueGrey,
      toolbarWidgetColor: Colors.white,
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    Navigator.pop(context, croppedFile);

  }

  imgtobase64(File photo){
    var base64Image = photo != null ? base64Encode(photo.readAsBytesSync()) : "";
    return base64Image;
  }

}