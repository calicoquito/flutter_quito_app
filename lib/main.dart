import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helperclasses/projectsbloc.dart';
import 'openscreen.dart';
import 'signinscreen.dart';
//import 'signupscreen.dart';


/* 
 * This file houses the entry point to the app
 * Here the MaterialApp widget is wrapped with a ChangeNotifierProvider
 * to all the notifier to alert listeners located on every Navigation route 
 * that the app may span.
 *
 * Here, onGenerateRoute is also used to allow data to be passed from route to route
 * at the time the route is being created
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectsBloc>.value(
      value: ProjectsBloc(),
      child: MaterialApp(
        title: 'Quito',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff7e1946),
          buttonTheme: ButtonThemeData(
            minWidth: 50,
            height: 30
          )
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings){
          if(settings.name=='/home'){
            return MaterialPageRoute(
              settings: settings,
              maintainState: true,
              builder: ((context){
                return OpenScreen(user: settings.arguments,);
              })
            );
          }
        },
        routes: <String, WidgetBuilder>{
          '/':(context)=>HomePage(),
        },
      ),
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
    return WillPopScope(
      onWillPop:() async{
        return showDialog(context: context, 
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Exit?'),
              children: <Widget>[
                SimpleDialogOption(
                  child: FlatButton(
                    child: Text('Yes'),
                    onPressed: (){
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                SimpleDialogOption(
                  child: RaisedButton(
                    textColor: Colors.black,
                    child: Text('No'),
                    onPressed: (){
                      Navigator.pop(context, false);
                    },
                  ),
                )
              ],
            );
          }
        );
      } ,
      child: Scaffold(
        body: SignInScreen(),
      ),
    );
  }
}
