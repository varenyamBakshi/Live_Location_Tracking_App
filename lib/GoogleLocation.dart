import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_location_tracking_app/crud.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  late Crud currentUser;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    currentUser = new Crud();
    data = currentUser.fetchData();
  }

  late GoogleMapController myController;
  CameraPosition camera = CameraPosition(
    target: LatLng(-34.0, 67.43),
    zoom: 12.0,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600.0,
          width: double.infinity,
          child: GoogleMap(
            compassEnabled: true,
            initialCameraPosition: camera,
            onMapCreated: (controller) {
              setState(() {
                myController = controller;
                camera = CameraPosition(
                  target: data['location'].point,
                  zoom: 18.0,
                  tilt: 30.0,
                );
              });
              print(data["location"].point);
            },
          ),
        )
      ],
    );
  }
}
