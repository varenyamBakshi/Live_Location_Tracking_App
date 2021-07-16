import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

late String Grpid;
late double _userlat;
late double _userlong;

class GroupMap extends StatelessWidget {
  late String _title;

  GroupMap(
      {required String grpid,
      required String Title,
      required double userlat,
      required double userlong}) {
    Grpid = grpid;
    _title = Title;
    _userlat = userlat;
    _userlong = userlong;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/Groups");
            }
          ),
          title: Text(_title),
        ),
        body: FireMap(),
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  const FireMap({Key? key}) : super(key: key);

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  Set<Marker> markers = new Set<Marker>();

  // variables for slider widget
  double _value = 300.0;
  String _label = 'Adjust Radius';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _uid = _auth.currentUser!.uid.toString();
  // for retrieving location data
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('groups');
  BehaviorSubject<double> radius = BehaviorSubject();

  late Stream<List<DocumentSnapshot>> stream;

  // will store logged in user's current location
  Location location = new Location();
  late String _GrpId;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _GrpId = Grpid;

    GeoFirePoint center =
        Geoflutterfire().point(latitude: _userlat, longitude: _userlong);
    radius.add(100.0);
    stream = radius.switchMap((rad) {
      print('rad value : $rad');
      return Geoflutterfire()
          .collection(
              collectionRef:
                  collectionReference.doc(Grpid).collection('Location'))
          .within(
              center: center, radius: rad, field: 'position', strictMode: true);
    });

    // _initializemarkers();
  }

  // _initializemarkers() async{
  //
  // }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        GoogleMap(
          zoomGesturesEnabled: true,
          markers: markers,
          compassEnabled: true,
          initialCameraPosition:
              CameraPosition(target: LatLng(_userlat, _userlong), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled:
              true, // Add little blue dot for device location, requires permission from user
        ),
        Container(
          height: 130.0,
          width: 160.0,
          child: Slider(
            min: 1,
            max: 1000,
            divisions: 200,
            activeColor: Colors.deepPurple.withOpacity(0.5),
            inactiveColor: Colors.deepPurpleAccent,
            value: _value,
            label: _label,
            onChanged: (double value) => changed(value),
          ),
        ),
      ],
    );
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      //markers.clear();
      radius.add(value);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    print('onMapCreated called');
    setState(() {
      mapController = controller;
    });
    // listen to the change in location of current user
    location.onLocationChanged.listen((event) {
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude!, event.longitude!),
            zoom: radius.hasValue
                ? log(156543.03392 / (radius.value)) / log(2.0)
                : 10.0,
          ),
        ),
      );
      GeoFirePoint myLocation = Geoflutterfire()
          .point(latitude: event.latitude!, longitude: event.longitude!);
      updateDB(myLocation);
    });

    stream.listen((List<DocumentSnapshot> documentList) {
      //markers.clear();

      _updateMarkers(documentList);
    });
  }

  _updateMarkers(List<DocumentSnapshot> documentList) {
    print('updating markers');
    documentList.forEach((DocumentSnapshot document) {
      print(document.data());
      final GeoPoint point = document['position']['geopoint'];
      setState(() {
        _addMarker(point.latitude, point.longitude, document['name']);
      });
    });
    print(markers);
  }

  _addMarker(double lat, double long, String name) {
    print('adding marker $name');
    markers.add(Marker(
        markerId: MarkerId(name),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: name,
          snippet: 'Latitude: $lat , longitude: $long',
        )));
  }

  updateDB(GeoFirePoint myLocation) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(_GrpId)
        .collection('Location')
        .doc(_uid)
        .set({
      'name': _auth.currentUser!.displayName.toString(),
      'position': myLocation.data,
    });
  }
}
