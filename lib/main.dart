import 'package:flutter/material.dart';
import 'signinscreen.dart';
//import 'signupscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        'login': (context)=>SignInScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.verified_user),
        title: Text("Quito"),
        centerTitle: true,
      ),
      body: SignInScreen(),
    );
  }
}




// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// floatingActionButton: RaisedButton(
//   textColor: Colors.white,
//   color: Colors.blue,
//   splashColor: Colors.cyan,
//   shape: StadiumBorder(),
//   onPressed: (){},
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisSize: MainAxisSize.min,
//     children: <Widget>[
//       Text('Login'),
//       Icon(Icons.arrow_forward),
//     ],
//   )
// )
