import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_core/firebase_core.dart';

class Crud{

  String collectionName = 'data';

  Crud ([String? collection]){
    this.collectionName = collection ?? 'data';
    return;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;


  addUser ({Position? loc}) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(this.collectionName);

    String uid = this._auth.currentUser!.uid.toString();
    print(uid);
    //var loc = {"Latitude": lat, "Longitude": long};
    collectionReference.doc(uid).set(
        {
          "full_name": this._auth.currentUser!.displayName.toString(),
          "email": this._auth.currentUser!.email.toString(),
          "uid": uid,
          "location": loc.toString(),
        }
    );
    print("New user added");
    return;
  }

  fetchData () async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(this.collectionName);

    collectionReference.doc(this._auth.currentUser!.uid).get().then((value){
      print(value.data());
    });
  }

  updateData({String? full_name, String? email }) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(this.collectionName);

    if(full_name != null){
      collectionReference.doc(this._auth.currentUser!.uid).update({
        "full_name": full_name,
      });
      print("full_name updated");
    }
    if(email != null){
      collectionReference.doc(this._auth.currentUser!.uid).update({
        email: email,
      });
      print("email updated");
    }


  }

  deleteData () async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(this.collectionName);
    collectionReference.doc(this._auth.currentUser!.uid).delete().then((_) {
      print("User deleted");
    });
  }

  deleteUser() async {
    deleteData();
    _auth.currentUser!.delete();
  }

  UpdateUser({String? full_name, String? email }) async{

    if(full_name != null){
      _auth.currentUser!.updateDisplayName(full_name);
    }
    if(email != null ){
      _auth.currentUser!.updateEmail(email);
    }
    updateData(full_name : full_name, email : email);
  }


}