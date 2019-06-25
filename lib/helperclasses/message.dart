import 'package:flutter/material.dart';

abstract class Message extends StatelessWidget{
  final String message;

  Message({Key key, this.message}):super(key:key);

}

class OutgoingMessage extends Message{
  @override
  OutgoingMessage({Key key, String message}):super(key:key, message:message);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width,
      child: Card(child: Text(message)),
    );
  }
}

class IncomingMessage extends Message{
  @override
  IncomingMessage({Key key, String message}):super(key:key, message:message);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width,
      child: Card(child: Text(message)),
    );
  }
}