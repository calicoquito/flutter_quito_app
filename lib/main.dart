import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helperclasses/projectsbloc.dart';
import 'openscreen.dart';
import 'signinscreen.dart';
//import 'signupscreen.dart';

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
