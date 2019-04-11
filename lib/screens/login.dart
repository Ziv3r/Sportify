import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State <Login>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login "),
       ),
       body: Column(children: <Widget>[
          Image.asset('images/twitter_header_photo_1.png'),
           TextField(
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
            ),
          ),
            TextField(
            keyboardType: (TextInputType.number),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
            ),
          ),
          Row(children: <Widget>[
              Text("dont have acout yey ? "),
          RaisedButton(
           child: Text("continue with faceBook"),
           onPressed: () {
             Navigator.pop(context);
             Navigator.pushNamed(context, '/home');
           },),
          ],),
       ],)
      ,);
  }

}