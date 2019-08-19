import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'helperclasses/user.dart';
import 'router.dart';

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
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) => User(),
      child: MaterialApp(
        title: 'Quito',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xff7e1946),
            primarySwatch: MaterialColor(0xff7e1946, {
              50: Color.fromRGBO(112, 25, 70, 0.1),
              100: Color.fromRGBO(112, 25, 70, 0.2),
              200: Color.fromRGBO(112, 25, 70, 0.3),
              300: Color.fromRGBO(112, 25, 70, 0.4),
              400: Color.fromRGBO(112, 25, 70, 0.5),
              500: Color.fromRGBO(112, 25, 70, 0.6), // creates a material color from these shades
              600: Color.fromRGBO(112, 25, 70, 0.7),
              700: Color.fromRGBO(112, 25, 70, 0.8),
              800: Color.fromRGBO(112, 25, 70, 0.9),
              900: Color.fromRGBO(112, 25, 70, 1),
            }),
            buttonTheme: ButtonThemeData(minWidth: 50, height: 30)),
        home: Router()
      ),
    );
  }
}

// Not Used
// child: ChangeNotifierProvider<ProjectsBloc>.value(
//         value: ProjectsBloc(),
