import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quito_1/openscreen.dart';
import 'dart:async';
import 'helperclasses/user.dart';

class SplashScreen extends StatefulWidget{
  final User user;

  const SplashScreen({Key key, this.user}) : super(key: key);
  

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // static AnimationController controller;

  // Animation<Color> animation;

  List<Map<String, String>> teams = List();
  Map<String, String> members  = Map();


  Future<void> getTeams() async {
    final resp = await http.get(
      'http://mattermost.alteroo.com/api/v4/users/${widget.user.userId}/teams',
      headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
    );
    final json = jsonDecode(resp.body);
    json.forEach((team){
      teams.add({
        'id': team['id'],
        'name':team['name']
      });
    });
    for (var team in teams){
      final resp = await http.get(
        'http://mattermost.alteroo.com/api/v4/users?team=${team.keys.toList()[0]}',
        headers: {'Authorization':'Bearer ${widget.user.mattermostToken}'}
      );
      final jsonData = jsonDecode(resp.body);
      jsonData.forEach((member){
        members.addAll({
          'id': member['id'], 
          'username': member['username'],
          member['id']: member['username'],
          'team_id':team['id']});
      });
    }
  }

  @override
  void initState(){
    super.initState();
  //   controller = AnimationController(vsync: this);
  //   animation = Tween<Color>(
  //     begin: Colors.blue,
  //     end: Colors.purple
  //   ).animate(
  //     CurvedAnimation(
  //       parent: controller,
  //       curve: Curves.linear
  //     )
  // );
    
    getTeams()
    .whenComplete((){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=>OpenScreen(user: widget.user,)
        )
      );
    });
  }

  @override
  void dispose() {
    // controller.dispose();
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