import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'task.dart';
import 'dart:math';

class TaskList extends StatefulWidget{

  TaskListState createState() => TaskListState();

}

class TaskListState extends State<TaskList>{

  
  @override
  Widget build(BuildContext context){
    final List data = ['hey', 'how', 'hall', 'hat', 'ham', 'heap', 'help', 'health', 'hemp', 'hex', 'hack', 'hump'];

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
                        style: TextStyle(color: Colors.white, fontSize: 20)
                        ),
                        radius:48.0,
                        backgroundColor: Colors.primaries[Random().nextInt(15)],
                      ),
                      title: Text(
                          "Task Name: Task $index"),
                      subtitle: Text("Task Data: To do ${data[index]} ",
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
          'Tasks',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20.0),
        )
      ),
      body: Container(child: lst(Icon(Icons.person), data)
        ),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){return Task();}));
        },
      ),
    );
  }
}


