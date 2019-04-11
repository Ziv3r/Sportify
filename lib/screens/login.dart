import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final server = '192.168.137.1';
String tokenOfConnection ;

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State <Login>{

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login "),
       ),
       body: Column(children: <Widget>[
          Image.asset('images/twitter_header_photo_1.png'),
           TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
            ),
          ),
            TextField(
            controller: _passwordController,
            //keyboardType: (TextInputType.number),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
            ),
          ),
          Row(children: <Widget>[
              Text("dont have acout yet ?"),
               RaisedButton(
           child: Text("login"),
           onPressed: () {
            http.post('http://${server}:8000/profile/login',
            body:json.encode({"email":_emailController.text,"password":_passwordController.text}),
            headers: {'Content-Type' : 'application/json'},
            ).then((reply){
              if(reply.statusCode==200){
                final temp = json.decode(reply.body);
                tokenOfConnection = temp['token'];
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(
                  content:Text("connection failed"),
                ));
              }
            });
            
             
           },),
          RaisedButton(
           child: Text("Signup"),
           onPressed: () {
            http.post('http://${server}:8000/profile/signup',
            body:json.encode({"email":_emailController.text,"password":_passwordController.text}),
            headers: {'Content-Type' : 'application/json'},
            ).then((reply){
              if(reply.statusCode==201){
                final temp = json.decode(reply.body);
                
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(
                  content:Text("connection failed"),
                ));
              }
            });
            
             
           },),
          ],),
       ],)
      ,);
  }

}