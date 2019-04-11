import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart' as daUser;

final server = '192.168.137.1';

class SearchBy extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SearchByState();
  }
}

class _SearchByState extends State <SearchBy>{
  DateTime _day = DateTime.now();
  TimeOfDay _start = TimeOfDay.now();
  TimeOfDay _end = TimeOfDay.now();
  static List<String> filterBy = List<String>();
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(title:Text("Search Events"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.play_arrow),
        onPressed: (){

        },)
      ],),
      body:Column(children: <Widget>[
        Row(children: <Widget>[
        FlatButton(
          child: Text(_day.day.toString() + '/' + _day.month.toString()),
          onPressed:(){
            _pickDate(context);
          }),
           FlatButton(
          child: Text(_start.hour.toString() + ':' + _start.minute.toString()),
          onPressed:(){
           _pickUpStartHour(context);
          }),
           FlatButton(
          child: Text(_end.hour.toString() +':' + _end.minute.toString()),
          onPressed:(){
            _pickUpEndHour(context);
          }),
        ],),
       Container ( 
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 110.0,
          width: double.infinity,
          child : ListView(
      //scrollDirection: Axis.horizontal,
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
          value: filterBy.contains("work-out"),
          title: Text("work-out"),
          onChanged: (value) {
            setState(() {
              value? filterBy.add("work-out"): filterBy.remove("work-out"); 
            });
          },
        )
      ],
    )),
    Container(color: Colors.grey,
    height: 5.0,),
     Container(
       height: 450.0,
       width: double.infinity,
       child: futureBuilder,)
      ],) ,
      
    );

  }

 void _pickDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2021),
    ).then((onValue){
      setState(() {
        
      _day = onValue;
      });
    });
  }

  void _pickUpStartHour(BuildContext context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((onValue){
      setState(() {
      _start = onValue;
        
      });
    });
  }

  void _pickUpEndHour(BuildContext context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((onValue){
      setState(() {
        _end = onValue;
      });
      
    });
  }

Future<List<String>> _getData() async {
    var values = new List<String>();
    final reply = await http.get('http://' +
                server +
                ':8000/event',
                headers: {'Authorization' : 'Bearer ${daUser.tokenOfConnection}'});
          final _body = json.decode(reply.body);
          final List<dynamic> _tmp = _body['events'];
          
          final List<String> _ids = _tmp.cast<String>().toList();
          //final _tmp = Map<String, dynamic>.from(_body);
          //final _tmp = _body['events'] as List;
          //final _id_list = List<String>.from(_tmp.values);
          await Future.forEach(_ids, ((id) async {
            final inreply = await http.get("http://" + server + ":8000/event?id=$id");
              final _body = json.decode(inreply.body);
              final _tmp = _body["event"]["name"];
              //final String __name = _tmp.cast<String>();
              values.add(_tmp);
              
            }) );
            debugPrint(values.toString());
    return values;
  }
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<String> values = snapshot.data;
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(values[index]),); 
        },
    );
  }
}

