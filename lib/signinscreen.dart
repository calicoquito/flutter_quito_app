import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'helperclasses/user.dart';
import 'splashscreen.dart';
import 'dart:convert';

/*
  This screen allows a user to enter his/her username and password
  and if valid will take him/her to the OpenScreen route defined in 
  this application, if not, then the user will be notifed.

  This widget is stateful so as to allow storing of the user's username
  and password as well as to initialize an User object which will be 
  shared further down the app's paths

  This class makes use of the SnackBar widget to allow a pop up the 
  screen when an action is performed and in this case, it is tapping 
  the Login button. This used to let the user know that the app is 
  processing his/her login. This process is making a POST request to
  the web server with the user's credentials to authenticate the 
  inputted data.
*/

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String usernameErrorString;
  bool isLoading;
  bool isTyping;
  

  void handleChange(String text) {
    setState(() {
      isTyping = true;
      usernameErrorString = null;
    });
  }

  void handleSubmit() {
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameErrorString = "Must not be empty";
      });
    }
    setState(() {
      isTyping = false;
    });
  }

  @override
  void initState() {
    super.initState();
    usernameErrorString = null;
    isLoading = false;
    isTyping = false;
    // if (User.signedin == true) {
    //     final User user = User.retrieve();
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => SplashScreen(user: user)));
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return WillPopScope(
      // Displays a dialog which will appear when a user hits the back button on the login screen
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Center(child: Text('Exit?')),
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SimpleDialogOption(
                      child: FlatButton(
                        shape: Border.all(
                            width: 2.0,
                            color: Theme.of(context).primaryColor),
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    SimpleDialogOption(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.black,
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    )
                  ],
                ),
              ],
            );
          }
        );
      },
      // the login screen
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 200,
                  child: Hero(
                      tag: 'logo',
                      child: SvgPicture.asset('images/quitologo.svg')),
                ),
                SizedBox(
                  height: 30.0,
                ),
                // Handles the username input
                TextField(
                  onChanged: handleChange,
                  controller: usernameController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: 'Username',
                      hintText: 'username',
                      errorText: usernameErrorString),
                ),
                SizedBox(
                  height: 30.0,
                ),
                PasswordTextField(
                  textEditingController: passwordController,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Builder(
                        builder: (context) => RaisedButton(
                          elevation: 10.0,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                !isLoading
                                ?Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )
                                :Container(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onPressed: () async {
                            if (usernameController.text.isEmpty) {
                              setState(() {
                                usernameErrorString = "Must not be empty";
                              });
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              final responses = await Future.wait([
                                http.post(
                                  'http://calico.palisadoes.org/@login',
                                  headers: {
                                    "Accept": "application/json",
                                    "Content-Type": "application/json"
                                  },
                                  body: jsonEncode({
                                    "login": usernameController.text.trim(),
                                    "password": passwordController.text.trim()
                                  })
                                ),
                                http.post(
                                  'http://mattermost.alteroo.com/api/v4/users/login',
                                  headers: {
                                    'Accept': 'application/json',
                                    'Content-Type': 'application/json'
                                  },
                                  body: jsonEncode({
                                    'login_id': usernameController.text.trim(),
                                    'password': passwordController.text.trim()
                                  })
                                )
                              ]);

                              if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
                                final ploneJson = jsonDecode(responses[0].body);
                                final mattermostJson = jsonDecode(responses[1].body);

                                user.username =  usernameController.text.trim();
                                user.password = passwordController.text.trim();
                                user.ploneToken = ploneJson['token'];
                                user.userId = mattermostJson['id'];
                                user.email = mattermostJson['email'];
                                user.mattermostToken = responses[1].headers['token'];

                                await user.login();
                                
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context)=> SplashScreen(user:user)
                                  )
                                );

                                setState(() {
                                  usernameController.clear();
                                  passwordController.clear();
                                  isLoading = false;
                                });
                              } 
                              else {
                                setState(() {
                                  isLoading = false;
                                });
                                print('Username or password incorrect');
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context).backgroundColor,
                                  content: Text(
                                    'Username or password incorrect',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ));
                              }
                            } 
                            catch (err) {
                              setState(() {
                                isLoading = false;
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: Theme.of(context).backgroundColor,
                                content: Text( 'Check internet connection',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                            }
                          }
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Forgot Password?',
                        style: TextStyle(color: Colors.pink),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Forgot password');
                          }
                      )
                    ),
                  ]
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

/*
  This class is reponsible for rendering the password field. This was 
  separated from the above code for readablilty sake as a few extra 
  features were added to this widget to improve user experience
*/

class PasswordTextField extends StatefulWidget {
  final String errorString;
  PasswordTextField({Key key, this.textEditingController, this.errorString});

  final TextEditingController textEditingController;
  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool isPressed = false;
  Icon icon = Icon(
    Icons.visibility_off,
    size: 18,
  );

  void handlePress() {
    setState(() {
      if (!isPressed) {
        isPressed = true;
        icon = Icon(
          Icons.visibility,
          size: 18,
        );
      } else {
        isPressed = false;
        icon = Icon(
          Icons.visibility_off,
          size: 18,
        );
      }
    });
  }

  void handleChange(String string) {
    if (isPressed) {
      setState(() {
        isPressed = false;
        icon = Icon(Icons.visibility_off, size: 18);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      obscureText: !isPressed,
      onChanged: handleChange,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          labelText: 'Password',
          hintText: 'password',
          suffixIcon: FlatButton.icon(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              label: Text(''),
              icon: icon,
              onPressed: handlePress)),
    );
  }
}
