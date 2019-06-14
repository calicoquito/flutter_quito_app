import 'package:flutter/material.dart';
import 'signinscreen.dart';
import 'signupscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          SignInScreen(),
          SignUpScreen()
        ],
      ),
      bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue),
          child: TabBar(
            indicator: BoxDecoration(
              color: Colors.red
            ),
            labelColor: Colors.white,
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ],
          ),
        ),
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
