import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'newproject.dart';
import 'tasks.dart';
import 'dart:math';


class EventList extends StatefulWidget{

  EventListState createState() => EventListState();

}

class EventListState extends State<EventList>{
  final String url = "http://localhost:8080/Core/project-list/test-project";
  final List data = ['hey', 'how', 'hall', 'hat', 'ham', 'heap', 'help', 'health', 'hemp', 'hex', 'hack', 'hump'];


  // @override
  // void initState() {
  //   super.initState();
  //   getSWData();
  // }

  // Future<String> getSWData() async {
  //   var response = await http.get(url, headers: {"Accept": "application/json"});

  //   setState(() {
  //     var resBody = json.decode(response.body);
  //     data = resBody["results"];
  //     print(data as String);
  //   });

  //   return "Success!";
  // }



  
  @override
  Widget build(BuildContext context){

    Widget lst(Icon ico, List data) {
      return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0,left: 4.0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){return TaskList();}));
                      },
                      leading: CircleAvatar(
                        child: Text("${data[index].split('')[2]}", 
                        style: TextStyle(color: Colors.white, fontSize: 25, )
                        ),
                        radius:48.0,
                        backgroundColor: Colors.primaries[Random().nextInt(15)],
                      ),
                      title: Text(
                          "Event Name: Event $index "),
                      subtitle: Text("Event Data: Saying ${data[index]}",
                          style:
                              TextStyle(fontSize: 10.0, color: Colors.black54)),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20.0),
        )
      ),
      body: Container(child: lst(Icon(Icons.person), data)
        ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){return NewProject();}));
        },
      ),
    );
  }
}


