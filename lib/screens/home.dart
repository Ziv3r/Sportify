import 'package:flutter/material.dart';
import 'google_map.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
final server = '192.168.137.1';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var theDate = DateTime.now();

  void showEvent(BuildContext context, String eventId) {
    showModalBottomSheet(
      context: context,
      builder:(builder){
        http.get('http://${server}:8000/event/enroll?eventId=$eventId',
        headers: { 'Authorization' : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5vYW13YUBnbWFpbC5jb20iLCJ1c2VySWQiOiI1Y2FmNDI2ODUwMTVjZjBmNzYxOTdlNTIiLCJpYXQiOjE1NTQ5OTAzNjYsImV4cCI6MTU1NDk5Mzk2Nn0.0bCwaL0cEI5o87rafn1GaCAmx4wCpp4_eDxuTQejuzQ'},
        ).then((reply){
          final _body = json.decode(reply.body);
          ListView(children: <Widget>[
              ListTile(title: Text('Name: ' + _body['name'])),
              ListTile(title: Text('Category: '+ _body['category']),),
              ListTile(title: Text('Capacity: ' + _body['capacity'])),
              //ListTile(title: Text())
              Row(children: <Widget>[
                RaisedButton(child: Text('Join'),
                onPressed: (){},),
                RaisedButton(child: Text('Back'),
                onPressed: (){},)
              ],)
          ],);
        });
      }
    );
  }
  void showFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            
            title: Text("Filter your sport"),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      SimpleDialogOption(
                        child: Text("Select the date"),
                        onPressed: () {
                          _pickDate(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: Text("Select starting time"),
                        onPressed: () {
                          _pickUpStartHour(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: Text("Select finishing time"),
                        onPressed: () {
                          _pickUpEndHour(context);
                        },
                      ),
                    ],
                  )),
                  Container (
                    height: 150.0,
                    width: 150.0,
                    child :ListOfFilters()),
                ],
              )
            ],
          );
        });
  }

//---------------------------------------edit your time of searching -------------
  void _pickDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2021),
    );
  }

  void _pickUpStartHour(BuildContext context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  void _pickUpEndHour(BuildContext context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

//---------------------------------------end edit your time of searching -------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sportify"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              debugPrint("my notification");
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(child: Text("Menu")),
            ListTile(
              title: Text("Create Event"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/new_event');
              },
            ),
            ListTile(
              title: Text("Search by"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search_by');
              },
            ),
            ListTile(
              title: Text("Events "),
              onTap: () {},
            ),
            ListTile(
              title: Text("My Events "),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          showFilter(context);
        },
      ),
      body: MyGoogleMap(),
      bottomNavigationBar: Text(
        "Searching 11/14 from 10:00 to 14:00",
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

//---------------------------------------class of List of filters -------------//
class ListOfFilters extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListOfFilersState();
  }
}

class _ListOfFilersState extends State<ListOfFilters> {
  static List<String> filterBy = List<String>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        CheckboxListTile(
          value: filterBy.contains("socer"),
          title: Text("Soccer"),
          onChanged: (value) {
            setState(() {
                           value? filterBy.add("socer"): filterBy.remove("socer");
 
            });
          },
        ),
        CheckboxListTile(
          value: filterBy.contains("basket-ball"),
          title: Text("Basket-ball"),
          onChanged: (value) {
            setState(() {
              value? filterBy.add("basket-ball"): filterBy.remove("basket-ball");
            });
          },
        ),
        CheckboxListTile(
          value: filterBy.contains("work-out"),
          title: Text("work-out"),
          onChanged: (value) {
            setState(() {
              value? filterBy.add("work-out"): filterBy.remove("work-out"); 
            });
          },
        )
      ],
    );
  }
}

//---------------------------------------class of List of filters -------------//
