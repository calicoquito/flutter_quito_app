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