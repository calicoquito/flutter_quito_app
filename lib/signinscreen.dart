import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helperclasses/user.dart';

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

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        child: Scaffold(
                          body:Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Loading'),
                                SizedBox(height: 30.0,),
                                CircularProgressIndicator(),
                              ],
                            )
                          )
                        )
                      ),
                    )
                  );
                  http.post('http://192.168.137.198:8080/Plone', 
                    headers: {"Accept":"application/json", 
                    "Content-Type":"application/json", 
                    "Authorization":"Basic YWRtaW46YWRtaW4="}, 
                    body: jsonEncode({"username":usernameController.text.trim(), "password":passwordController.text.trim()}))
                  .then((resp){
                    if(true){
                      Navigator.of(context).pushNamed('/home',arguments:user);
                    }
                    else {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:Theme.of(context).backgroundColor,
                          content: Text(
                            'Username or password incorrect',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      );
                    }
                  })
                  .catchError((err){
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:Theme.of(context).backgroundColor,
                        content: Text(
                          'Check internet connection',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    );
                  });
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

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: widget.textEditingController,
      obscureText: !isPressed,
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

