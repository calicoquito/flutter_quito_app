import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign Up',
              style: TextStyle(
              fontSize: 50.0,
              foreground: Paint()..shader = LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.yellow, Colors.teal]
                ).createShader(Rect.fromLTRB(90.0, 80.0, 200.0, 200.0))
              ),
            ),
            SizedBox(height: 30.0,),
            NameRow(),
            SizedBox(height: 30.0,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.all(13.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                labelText: 'Email address'
              ),
            ),
            SizedBox(height: 30.0,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.all(13.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                labelText: 'Number'
              ),
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              color: Colors.yellowAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Register'),
                    Icon(Icons.arrow_forward)
                  ],
                ),
                onPressed: (){},
            )
          ]
        )
      ),
    );
  }
}  

class NameRow extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 6,
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.all(13.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              labelText: 'First name'
            ),
          ),
        ),
        Spacer(flex: 1),
        Flexible(
          flex: 6,
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.all(13.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              labelText: 'Last name'
            ),
          ),
        )
      ],
    );
  }
}