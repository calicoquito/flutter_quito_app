import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogManager {
  static bool answer = false;

  static delete(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          // title: Text("Alert Dialog title"),
          content: Text(message,
              style: TextStyle(
                fontSize: 18.0,
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Delete",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                answer = true;
              },
            ),
            FlatButton(
              child: Text("Cancle",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                answer = false;
              },
            ),
          ],
        );
      },
    );
  }

  static complete(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          // title: Text("Alert Dialog title"),
          content: Text(message,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Confirm",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue[800],
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                answer = true;
              },
            ),
            FlatButton(
              child: Text("Cancle",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                answer = false;
              },
            ),
          ],
        );
      },
    );
  }

  static okay(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          // title: Text("Alert Dialog title"),
          content: Text(message,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("OK",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w600

                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
