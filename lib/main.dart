import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/new_event.dart';
import 'screens/my_events.dart';
import 'screens/search_by.dart';

void main() => runApp(MySportify());

class MySportify extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sportify",
      home : Login(),
      routes: {
        '/home':(context)=>Home(),
        '/login':(context)=>Login(),
        '/new_event' : (context)=>NewEvent(),
        '/my_events':(context)=>MyEvents(),
        '/search_by':(context)=>SearchBy(),
      },
      );
  }
}


