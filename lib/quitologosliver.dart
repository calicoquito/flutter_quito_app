import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuitoLogoSliver extends StatefulWidget{
  final Widget child;

  const QuitoLogoSliver({Key key, this.child}) : super(key: key);

  @override
  _QuitoLogoSliverState createState() => _QuitoLogoSliverState();
}

class _QuitoLogoSliverState extends State<QuitoLogoSliver> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Quito',
              style: TextStyle(
                color: Colors.amber
              ),
            ),
            pinned: true,
            floating: true,
            expandedHeight: MediaQuery.of(context).size.height*0.10,
            snap: true,
            elevation: 10,
            flexibleSpace: SvgPicture.asset(
              'images/quitologo.svg',
              allowDrawingOutsideViewBox: true,
              placeholderBuilder: (context){
                return Center(child: Icon(Icons.person_outline));
              },
            ),
          ),
         SliverFillRemaining(child: widget.child,hasScrollBody: true,)
        ],
      ),
    );
  }
}



  // Widget appBarTitle = Text('Projects');
  // Icon actionIcon = Icon(Icons.search);
  // var respBody;
  // List saveimage = List();
  // int count = 1;
  // List holder = List();
  // List completelist = List();

  // void setsearchdata() {
  //   if (count == 1) {
  //     holder = data;
  //   }
  //   setState(() {
  //     data = data;
  //   });
  //   count += 1;
  // }

     // appBar: AppBar(title: appBarTitle,
      // //backgroundColor: Colors.transparent,
      //  actions: <Widget>[
      //   IconButton(
      //     icon: actionIcon,
      //     onPressed: () {
      //       setState(() {
      //         if (actionIcon.icon == Icons.search) {
      //           actionIcon = Icon(Icons.close);
      //           appBarTitle = TextField(
      //             style: TextStyle(
      //               color: Colors.white,
      //             ),
      //             decoration: InputDecoration(
      //                 prefixIcon: Icon(Icons.search, color: Colors.white),
      //                 hintText: "Search...",
      //                 hintStyle: TextStyle(color: Colors.white)),
      //             onChanged: (text) {
      //               if (data.length < holder.length) {
      //                 data = holder;
      //               }
      //               text = text.toLowerCase();
      //               setState(() {
      //                 data = data.where((project) {
      //                   var name = project["title"].toLowerCase();
      //                   return name.contains(text);
      //                 }).toList();
      //               });
      //               setsearchdata();
      //             },
      //           );
      //         } else {
      //           actionIcon = Icon(Icons.search);
      //           appBarTitle = Text('Projects');
      //         }
      //       });
      //     },
      //   ),
      // ]),