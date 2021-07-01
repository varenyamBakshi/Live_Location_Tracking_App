import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './Signup.dart';
import './Login.dart';
import 'package:flutter/gestures.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      backgroundColor: Color(0xff121212),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Welcome Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Roboto',
                )
              ),
              RichText(
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
            ],
          ),
        ),
      ),
      ),

    );
  }
}
