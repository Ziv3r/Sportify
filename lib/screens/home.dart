import 'package:flutter/material.dart';
import 'google_map.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'login.dart' as daUser;

final server = '192.168.137.1';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var theDate = DateTime.now();


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
  void showEvent(BuildContext context, String eventId) async{
    final reply = await http.get('http://${server}:8000/event?id=$eventId',
        headers: { 'Authorization' : 'Bearer ${daUser.tokenOfConnection}'},
        );
    showModalBottomSheet(
      context: context,
      builder:(builder){
        debugPrint(eventId);
          final _body = json.decode(reply.body)['event'];
         return ListView(children: <Widget>[
              ListTile(title: Text('Name: ' + _body['name'])),
              ListTile(title: Text('Category: '+ _body['category']),),
              ListTile(title: Text('Capacity: ' + _body['maxCapacity'].toString())),
              ListTile(title: Text('Description: ' + _body['description'])),
              Row(children: <Widget>[
                Expanded( child:RaisedButton(child: Text('Join'),
                onPressed: (){
                  http.post('http://${server}:8000/profile/enroll?id=$eventId',
                     headers: { 'Authorization' : 'Bearer ${daUser.tokenOfConnection}'}).then((reply){
                       debugPrint('Joined successfuly');
                         Navigator.pop(context);
                     });
                },),),
                Expanded(child: RaisedButton(child: Text('Back'),
                onPressed: (){
                  Navigator.pop(context);
                },))
              ],)
          ],);
      }
    );
  }