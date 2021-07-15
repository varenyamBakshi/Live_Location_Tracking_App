import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

late String Grpid;

class GroupMap extends StatelessWidget {
  late String _title;

  GroupMap(String grpid, String Title) {
    Grpid = grpid;
    _title = Title; //.................;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _uid = _auth.currentUser!.uid.toString();

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

    // GeoFirePoint center =
    //     Geoflutterfire().point(latitude: location., longitude:longitude of user);
    //     stream = radius.switchMap((rad) {
    //   return Geoflutterfire()
    //       .collection(
    //       collectionRef:
    //       collectionReference.doc(Grpid).collection('locations'))
    //           .within(
    //       center: center, radius: rad, field: 'position', strictMode: true);
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled:
              true, // Add little blue dot for device location, requires permission from user
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // listen to the change in location of current user
    location.onLocationChanged.listen((event) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude!, event.longitude!),
          ),
        ),
      );
      GeoFirePoint myLocation = Geoflutterfire()
          .point(latitude: event.latitude!, longitude: event.longitude!);
      updateDB(myLocation);
    });
    setState(() {
      mapController = controller;
    });
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
