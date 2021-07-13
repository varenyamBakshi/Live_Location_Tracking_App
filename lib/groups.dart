import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_core/firebase_core.dart';


class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {

  late Stream<QuerySnapshot> cr;

  @override
  void initState() {

    FirebaseAuth _auth = FirebaseAuth.instance ;
    cr = FirebaseFirestore.instance.collection('groups').where('users', arrayContains: _auth.currentUser!.displayName).snapshots();

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DashBoard"),
      ),
      floatingActionButton: CircleAvatar(
        child: Icon(
            Icons.add,
        ),
        backgroundColor: Colors.blue,
        radius: 25.0,

      ),

      body: StreamBuilder(
          stream: cr,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      ListTile(
                        title: Text(document['groupName']),
                        subtitle: Text(document["users"].join(",  ")),
                      ),
                    ],
                  ),
                ),
                  ),
                );
              }).toList(),
            );
          }
      ),
    );
  }
}
