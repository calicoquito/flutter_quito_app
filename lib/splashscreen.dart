import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'openscreen.dart';
import 'dart:async';
import 'helperclasses/user.dart';

class SplashScreen extends StatefulWidget{
  final User user;

  const SplashScreen({Key key, this.user}) : super(key: key);
  

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  List<Map<String, String>> teams = List();
  Map<String, String> members  = Map();


  Future<void> getTeams() async {
    try{
      final resp = await http.get(
        'http://mattermost.alteroo.com/api/v4/users/${widget.user.userId}/teams',
        headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
      );
      final json = jsonDecode(resp.body);
      
      json.forEach((team){
        setState(() {
          teams.add({
            'id': team['id'],
            'name':team['name']
          });
        });
        
      });
      for (var team in teams){
        final resp = await http.get(
          'http://mattermost.alteroo.com/api/v4/users?team=${team.keys.toList()[0]}',
          headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
        );
        final jsonData = jsonDecode(resp.body);
        jsonData.forEach((member){
          setState(() {
            members.addAll({
              'id': member['id'], 
              'username': member['username'],
              member['id']: member['username'],
              'team_id':team['id']
            });
          });
        });
      }
    }
    catch(err){
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 5),
        message: "An error has occured",
      )..show(context);
    }
  }

  @override
  void initState(){
    super.initState();    
    getTeams()
    .whenComplete((){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context)=>OpenScreen(user: widget.user,)
        ),
        (route)=>false
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final User user = Provider.of<User>(context);
    user.members = members;
    user.teams = teams;
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.3 ,
              child: Hero(tag:'logo', child: SvgPicture.asset('images/quitologo.svg')),
            ),
            SizedBox(height: 30,),
            CircularProgressIndicator()
          ] 
        ),
      ),
    );
  }
}