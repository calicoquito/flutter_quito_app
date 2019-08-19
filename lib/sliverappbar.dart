import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuitoLogoSliver extends StatefulWidget{

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
            title: Text('Quito'),
            pinned: true,
            floating: true,
            expandedHeight: MediaQuery.of(context).size.height*0.20,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index){
                return ListTile(
                  title: Text('Yow a me this'),
                );
              },
              childCount: 100
            ),
          )
        ],
      ),
    );
  }
}