import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  User user = User('username', 'password');

  @override
  Widget build(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.red
              )
            ),
            SizedBox(height: 30.0,),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.all(13.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                labelText: 'Username'
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
                shape: StadiumBorder(),
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
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
                  });

                  showDialog(context: context, 
                    builder: (context) => Material(
                      elevation: 10.0,
                      type: MaterialType.transparency,
                      child:Center(
                        child: CircularProgressIndicator()
                      )
                    ),
                  );
                  
                  Navigator.of(context).pushNamed('/home',arguments:user); //Temporary: For debugging without internet
                  
                  // http.post('http://my-json-server.typicode.com/typicode/demo/posts', 
                  //   headers: {"Accept":"application/json", 
                  //   "Content-Type":"application/json", 
                  //   "Authorization":"Basic YWRtaW46YWRtaW4="}, 
                  //   body: jsonEncode({"username":usernameController.text.trim(), "password":passwordController.text.trim()}))
                  // .then((resp){
                  //   if(true){
                  //     Navigator.of(context).pushNamed('/home',arguments:user);
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
            SizedBox(height: 40.0,),
            RawMaterialButton(
              onPressed: (){
                print('Forgot Password');
              },
              child: Text('Forgot Password?', style: TextStyle(color: Colors.pink),)
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
  Icon icon = Icon(Icons.visibility_off, size: 20,);

  void handlePress(){
    setState((){
      if (!isPressed){
        isPressed=true;
        icon = Icon(Icons.visibility, size: 20,);
      }
      else{
        isPressed=false;
        icon = Icon(Icons.visibility_off, size: 20,);
      }
    });
  }

  void handleChange(String _){
    if(isPressed){
      setState(() {
        isPressed=false;
        icon = Icon(Icons.visibility_off, size: 20,);
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
        contentPadding: EdgeInsets.only(left:10.0, ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0)
        ),
        labelText: 'Password',
        suffixIcon: FlatButton.icon(
          padding: EdgeInsets.all(0.0),
          label: Text(''),
          icon: icon,
          onPressed: handlePress
        )
      ),
    );
  }
}

