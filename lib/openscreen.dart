import 'package:flutter/material.dart';
import 'package:quito_1/sidedrawer.dart';
import 'newproject.dart';
import 'helperclasses/user.dart';

class OpenScreen extends StatelessWidget {

  OpenScreen({Key key, this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Hero(
          tag:'navdrawer',
          child: SideDrawer(user:ModalRoute.of(context).settings.arguments)
        ),
        appBar: AppBar(
          title: Text('Welcome'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Start something new today',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0
                )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push( context,
              MaterialPageRoute(
                builder: (context){
                  return NewProject(user:ModalRoute.of(context).settings.arguments);
                }
              )
            );
          },
          tooltip: 'New Event',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
} 
