import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'eventsinfo.dart';
import 'tasks.dart';
import 'dart:async';


class EventList extends StatefulWidget {
  EventListState createState() => EventListState();
}

class EventListState extends State<EventList> {
  final String url = "http://192.168.100.67:8080/Plone/projects";
  List data;
  List<String> image_links = List();
  List event_names = List();
  List event_links = List();

  @override
  void initState() {
    super.initState();
    getSWData();
  }


  Future<void> getSWData() async {
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    data = resBody["items"];


    Future<String> getimglinks(int i) async {
      try {
        var resp = await http
            .get(data[i]["@id"], headers: {
              "Accept": "application/json"});
        var respBody = json.decode(resp.body);
        if (respBody != null) {
          return respBody["image"]["scales"]["thumb"]["download"];
        }
      } catch (e) {}
    }

    gettitle(int i) {
      try {
        return data[i]["title"];
      } catch (e) {}
    }
    for (var i = 1; i <= data.length; i++) {
      var imgs = await getimglinks(i);
      if (imgs != null) {
        image_links.add(imgs);
      }
      if (i < data.length){
      event_links.add(data[i]["@id"]);
      event_names.add(data[i]["title"]);

      }
    }
    setState(() {
      image_links = image_links;
      event_names = event_names;
    });
    return "Success!";
  }

  Future delete(int index) async {
    String url = data[index]["@id"];
    var bytes = utf8.encode("admin:admin");
    var credentials = base64.encode(bytes);
    var resp = await http.delete(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Basic $credentials"
    },);
    print(resp.statusCode);
    return "Success!";
  }

  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Widget lst(Icon ico, List data) {
      return 
      ///RefreshIndicator(
        //key: _refreshIndicatorKey,
        //onRefresh: (){getSWData();},
        //child: 
        ListView.builder(
          itemCount: data == null ? 0 : data.length-1,
          itemBuilder: (BuildContext context, int index) {
            final item = data[index]["@id"];
            return Dismissible(
              direction: DismissDirection.startToEnd,
              background: Container(color: Colors.red,
              padding: EdgeInsets.only(right: 0.8 * width),
              child: Icon(Icons.delete, color: Colors.white)),
              key: Key(item),
              onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    data.removeAt(index);
                    delete(index);
                  });  
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 4.0, left: 4.0),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskList(url: data[index]["@id"]);
                        }));
                      },
                      leading: CircleAvatar(
                        radius: 28.0,
                        backgroundImage: NetworkImage(image_links[index]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text("Event Name: ${event_names[index]} "),
                      subtitle: Text("Event type: ${data[index]["@type"]}",
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
        //);
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Events',
        style: TextStyle(fontFamily: 'Nunito', fontSize: 20.0),
      )),
      body: Container(child:
       lst(Icon(Icons.person), data)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return EventsInfo();
          // }));
        },
      ),
    );
  }
}