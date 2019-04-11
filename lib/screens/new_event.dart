import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'google_map.dart' as myGoogleMap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'login.dart' as daUser;

const APIKEY = 'AIzaSyAMjQ6xo0LYjnq4s44QJvQ3io9W00WzaB4';
final server = '192.168.137.1';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: APIKEY);

class NewEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNewEventState();
  }
}

class _MyNewEventState extends State<NewEvent> {
  //field in state of widget
  static final category = [
    "Soccer",
    "BasketBall",
    "Work-out",
    "Volly-ball",
    "Riding"
  ];
  static var _myCategory = category[0];
  
  static final privacy = [
    "public",
    "private",
    "invite only"
  ];

  static var _myPrivacy = privacy[0];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _capacityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _location = "Academic Tel Aviv";

  Map<String,dynamic>request = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Event"),
      ),
      body: ListView(
        children: <Widget>[
          DropdownButton<String>(
            value: _myCategory,
            onChanged: (newValue) {
              setState(() {
                _myCategory = newValue;
              });
            },
            items: category.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
          ListTile(
            trailing: Icon(Icons.location_on),
            title: Text(_location),
            onTap: (){
              PlacesAutocomplete.show(
                context: context,
                apiKey: APIKEY,
                mode: Mode.overlay,
                
              ).then((value){
                _location = value.description;
                _places.getDetailsByPlaceId(value.placeId).then((newValue){
                  request['lat'] = newValue.result.geometry.location.lat;
                  request['long'] = newValue.result.geometry.location.lng;
                  //debugPrint(request['location']);
                  
                });
              });
            },
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Name your Event",
            ),
          ),
          TextField(
            controller: _capacityController,
            keyboardType: (TextInputType.number),
            decoration: InputDecoration(
              labelText: "capacity",
              hintText: "Max amont of patricipations",
            ),
          ),
           DropdownButton<String>(
            value: _myPrivacy,
            onChanged: (newValue) {
              setState(() {
                _myPrivacy = newValue;
              });
            },
            items: privacy.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
          TextField(
            controller: _descriptionController,
            keyboardType: (TextInputType.multiline),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Describe your event in few sentences",
            ),
          ),
          RaisedButton(
            child: Text("Submit&Invite"),
            onPressed: (){
              debugPrint("invite your friends dude ");
              
              
              request['name'] = _nameController.text; 
              request['maxCapacity'] =_capacityController.text; 
              request['description'] = _descriptionController.text; 
              request['category'] = _myCategory ; 

              debugPrint(json.encode(request));
              http.post('http://' + server +':8000/event',
              headers: { 'Authorization' : 'Bearer ${daUser.tokenOfConnection}',
                         'Content-Type' : 'application/json'},
              body: json.encode(request), 
              ).then((reply){
                debugPrint(reply.body);
              });

              myGoogleMap.myMarkers['dummyid'] = Marker(
                markerId: MarkerId('dummyid'),
                position: LatLng(request['lat'], request['long']), 
                onTap: (){}
                );

              //look for the googlemap Controler to add marker 

            },)
        ],
      ),
    );
  }
}
