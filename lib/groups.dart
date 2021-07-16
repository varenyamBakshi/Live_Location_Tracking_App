import 'dart:ui';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'GroupsMap.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  late Stream<QuerySnapshot> cr;
  bool groupChecker = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Location location = new Location();
  late final _currentlocation;
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) Navigator.pushReplacementNamed(context, "/Login");
    });
  }

  getLocation() async {
    _currentlocation = await location.getLocation();
  }
  //
  // // this function is temporary
  // void addSearchQueries() async {
  //
  //   var fb = FirebaseFirestore.instance.collection('data').snapshots();
  //
  //   await fb.forEach((element) async {
  //     List docs = element.docs;
  //
  //     for(var doc in docs){
  //
  //       List SearchQueries = [];
  //
  //       for (var i = 1; i <= doc["full_name"].length; i++) {
  //         SearchQueries.add(doc["full_name"].substring(0, i));
  //       }
  //
  //       print(doc["full_name"]);
  //
  //       await FirebaseFirestore.instance.collection('data').doc(doc.id).update(
  //           {
  //             "SearchQueries" : FieldValue.arrayUnion(SearchQueries),
  //           });
  //     }
  //   });
  //
  //
  //
  // }

  @override
  void initState() {
    FirebaseAuth _auth = FirebaseAuth.instance;

    cr = FirebaseFirestore.instance
        .collection('groups')
        .where('users', arrayContains: _auth.currentUser!.displayName)
        .snapshots();
    print("current username: ${_auth.currentUser!.displayName}");
    checkAuthentication();
    getLocation();

    //addSearchQueries();
    print("function completed");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DashBoard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: RichText(
              //for sign out and go back to login page
              text: TextSpan(
                  text: 'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      FirebaseAuth.instance.signOut();
                      //this.checkAuthentication();
                    }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffBB86FC),
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 36,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/Search");
        },
      ),
      backgroundColor: Color(0xff121212),
      body: _auth.currentUser!.displayName == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Center(
                  child: Text(
                      "Currently You are not in any group, for creating a new group tap the '+' button",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                  )),
            )
          : StreamBuilder(
              stream: cr,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    document['groupName'],
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    document["users"].join(",  "),
                                    style: TextStyle(color: Color(0xffBB86FC)),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GroupMap(
                                          grpid: document.id.toString(),
                                          Title:
                                              document['groupName'].toString(),
                                          userlat: _currentlocation.latitude,
                                          userlong: _currentlocation.longitude,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
    );
  }
}
