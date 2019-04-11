import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Map<String, Marker> myMarkers = new Map();
final server = '192.168.137.1';

class MyGoogleMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyGoogleMapState();
  }
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  static final CameraPosition myCamerPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: (20.0),
  );
  Completer<GoogleMapController> controller = Completer();

  @override
  Widget build(BuildContext context) {
    
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      markers: Set<Marker>.of(myMarkers.values),
      initialCameraPosition: myCamerPosition,
      onMapCreated: (GoogleMapController myController) {
        controller.complete(myController);
        Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      controller.future.then((onValue) {
        onValue.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 15.0)));
        http
            .get('http://' +
                server +
                ':8000/event?lat=${value.latitude}&long=${value.longitude}&radius=2000')
            .then((reply) {
          final _body = json.decode(reply.body);
          final List<dynamic> _tmp = _body['events'];
          
          final List<String> _ids = _tmp.cast<String>().toList();
debugPrint("flag");
          //final _tmp = Map<String, dynamic>.from(_body);
          //final _tmp = _body['events'] as List;
          //final _id_list = List<String>.from(_tmp.values);
          _ids.forEach((id) {
            http.get("http://" + server + ":8000/event?id=$id").then((inreply) {
              final _body = json.decode(inreply.body);
              final _tmp = _body["event"]["location"];
              final List<double> _coords = _tmp.cast<double>().toList();
              debugPrint("flag");
              setState(() {
                
              
              myMarkers[id] = Marker(
                markerId: MarkerId(id),
                position: LatLng(_coords[1], _coords[0])
              );
              });
            });
          });
        });
      });
    });
      },
    );
  }
}
