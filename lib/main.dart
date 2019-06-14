import 'package:flutter/material.dart';
import 'events.dart';
import 'openscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quito',
      theme: ThemeData(
        appBarTheme:AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          textTheme: TextTheme(title: TextStyle(color: Colors.black87)),
          ),
        fontFamily: 'Nunito',
        //primaryColor: Colors.black54,
        textTheme: TextTheme(
          title: TextStyle(color: Colors.black54,)
          ),),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        'new':(context)=>EventList()
      },
    );
  }
}