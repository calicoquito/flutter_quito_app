import 'package:flutter/material.dart';
import 'openscreen.dart';

class SignInScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login',
              style: TextStyle(
              fontSize: 50.0,
              foreground: Paint()..shader = LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.teal, Colors.yellow]
                ).createShader(Rect.fromLTRB(30.0, 10.0, 100.0, 100.0))
              ),
            ),
            SizedBox(height: 40.0,),
            TextField(
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
            SizedBox(height: 30.0,),
            PasswordTextField(),
            SizedBox(height: 20.0,),
            Center(
              child: RaisedButton(
                color: Colors.yellowAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Login'),
                    Icon(Icons.arrow_forward)
                  ],
                ),
                onPressed: (){
                  Navigator.of(context).push( 
                    MaterialPageRoute(
                      builder: (context){
                        return OpenScreen();
                      }
                    )
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget{
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

