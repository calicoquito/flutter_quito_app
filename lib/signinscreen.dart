import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helperclasses/user.dart';


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

class SignInScreen extends StatefulWidget{
  SignInScreen({Key key}):super(key:key);
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  User user = User(username: 'username', password: 'password', token: 'token');

  @override
  Widget build(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70,
              width:200,
              child: SvgPicture.asset('images/quitologo.svg'),
            ),
            SizedBox(height: 30.0,),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Username',
                hintText: 'username'
              ),
            ),
            SizedBox(height: 20.0,),
            PasswordTextField(
              textEditingController: passwordController,
            ),
            SizedBox(height: 30.0,),
            Center(
              child: RaisedButton(
                elevation: 10.0 ,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Login',style: TextStyle(color: Colors.white),),
                      Icon(Icons.arrow_forward, color: Colors.white,),
                    ],
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    user.username = usernameController.text.trim();
                    user.password = passwordController.text.trim();
                    user.userID = usernameController.text.trim();
                    //user.token = jsonDecode(resp.body)['token'];
                  });
                  Navigator.of(context).pushNamed('/home', arguments:user);
                                    
                  // http.post('http://10.22.0.63:8080/Plone/@login', 
                  //   headers: {"Accept":"application/json", 
                  //     "Content-Type":"application/json"}, 
                  //   body: jsonEncode({"login":usernameController.text.trim(), "password":passwordController.text.trim()}))
                  // .then((resp){
                  //   if(resp.statusCode==200){
                  //     setState(() {
                  //       user.username = usernameController.text.trim();
                  //       user.password = passwordController.text.trim();
                  //       user.token = jsonDecode(resp.body)['token'];
                  //     });
                  //     Navigator.of(context).pushNamed('/home', arguments:user);
                  //   }
                  //   else {
                  //     Navigator.pop(context);
                  //     Scaffold.of(context).showSnackBar(
                  //       SnackBar(
                  //         backgroundColor:Theme.of(context).backgroundColor,
                  //         content: Text(
                  //           'Username or password incorrect',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: Colors.red),
                  //         ),
                  //       )
                  //     );
                  //   }
                  // })
                  // .catchError((err){
                  //   print(err);
                  //   Navigator.pop(context);
                  //   Scaffold.of(context).showSnackBar(
                  //     SnackBar(
                  //       backgroundColor:Theme.of(context).backgroundColor,
                  //       content: Text(
                  //         'Check internet connection',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(color: Colors.red),
                  //       ),
                  //     )
                  //   );
                  // });
                }
              ),
            ),
            RawMaterialButton(
              onPressed: (){
                print('Forgot Password');
              },
              child: Text('Forgot Password?', style: TextStyle(color: Colors.pink),)
            ),
            SizedBox(height: 10.0,),
            Center(
              child: RaisedButton( 
                color: Theme.of(context).primaryColor, 
                child: Text('Sign in with Google',
                  style: TextStyle(color: Colors.white),),
                onPressed: (){},
              ),
            )
          ],
        )
      ),
    );
  }
}

/*
  This class is reponsible for rendering the password field. This was 
  separated from the above code for readablilty sake as a few extra 
  features were added to this widget to improve user experience
*/

class PasswordTextField extends StatefulWidget{
  PasswordTextField({Key key, this.textEditingController});

  final TextEditingController textEditingController;
  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField>{
  bool isPressed = false;
  Icon icon = Icon(Icons.visibility_off, size: 18,);

  void handlePress(){
    setState((){
      if (!isPressed){
        isPressed=true;
        icon = Icon(Icons.visibility, size: 18,);
      }
      else{
        isPressed=false;
        icon = Icon(Icons.visibility_off, size: 18,);
      }
    });
  }

  void handleChange(String _){
    if(isPressed){
      setState(() {
        isPressed=false;
        icon = Icon(Icons.visibility_off, size: 18,);
      });
    }
  }

  @override
  Widget build(BuildContext context){
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
          onPressed: handlePress
        )
      ),
    );
  }
}

