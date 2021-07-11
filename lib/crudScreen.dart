import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';
import 'package:firebase_core/firebase_core.dart';



class CrudScreen extends StatefulWidget {
  const CrudScreen({Key? key}) : super(key: key);

  @override
  _CrudScreenState createState() => _CrudScreenState();
}



// crud layout with buttons from the 1st video

class _CrudScreenState extends State<CrudScreen> {

  Map data = {} ;
  var location= "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkAuthentication() async {

    _auth.authStateChanges().listen((user) {
      if (user == null) Navigator.pushReplacementNamed(context, "/Login");
    }
    );
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    getCurrentLocation();
  }

  //Accessing Location
  getCurrentLocation() async{
    Position geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      location = "$geoposition";
    });
  }

  Future<void> addUser () async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid.toString();
    print(uid);

    collectionReference.doc(uid).set(
        {
          "full_name": _auth.currentUser!.displayName.toString(),
          "email": _auth.currentUser!.email.toString(),
          "uid": uid,
          "location": location,
        }
    );
    print("New user added");
    return;
  }

  fetchData () async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    FirebaseAuth _auth = FirebaseAuth.instance;
    collectionReference.doc(_auth.currentUser!.uid).get().then((value){
      print(value.data());
    });
  }

  updateData({String? full_name, String? email }) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(full_name != null){
      collectionReference.doc(_auth.currentUser!.uid).update({
        "full_name": full_name,
      });
      print("full_name updated");
    }
    if(email != null){
      collectionReference.doc(_auth.currentUser!.uid).update({
        email: email,
      });
      print("email updated");
    }


  }

  deleteData () async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    FirebaseAuth _auth = FirebaseAuth.instance;
    collectionReference.doc(_auth.currentUser!.uid).delete().then((_) {
      print("User deleted");
    });
  }
  //
  // CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');

  // addData(){
  //   Map<String, dynamic> demoData = {
  //     "name" : "Varshith",
  //     "Quote" : "Do things early or else you have to apologize",
  //   };
  //
  //   collectionReference.add(demoData);
  // }
  //
  // fetchData(){
  //   collectionReference.snapshots().listen((snapshot) {
  //
  //     List documents;
  //     setState(() {
  //       //data = snapshot.docs[0].data();
  //       }
  //     );
  //   });
  // }// not working
  //
  // deleteData () async{
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD operations to be performed'),

      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [

          RichText( //                              for sign out and go back to login page
            text: TextSpan(
            text: 'Sign Out',
              style: TextStyle(color: Colors.grey[700], fontSize: 20.0,),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                FirebaseAuth.instance.signOut();
                  //this.checkAuthentication();
                }
            ),
          ),

            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: fetchData,
              child: Center(
                child: Text(
                  'Fetch Data',                           //r
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            ElevatedButton(
              onPressed: addUser,
              child: Center(
                child: Text(
                  'Add Data',                              //c
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => updateData(full_name: "kancharla Varshith"),
              child: Center(
                child: Text(
                  'Update Data',                        //u
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => deleteData(),
              child: Center(
                child: Text(
                  'Delete Data',                      //d
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),



          ]
        ),
      ),
    );
  }
}

