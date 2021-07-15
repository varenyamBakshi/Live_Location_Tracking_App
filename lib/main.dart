import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './Signup.dart';
import './Login.dart';
import './Home.dart';
import './crudScreen.dart';
import 'GoogleLocation.dart';
import './Profile.dart';
import './groups.dart';
import './Search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp((MaterialApp(
    // initialRoute: ,
    home: LoginPage(),
    routes: {
      '/Home': (context) => HomePage(),
      '/Login': (context) => LoginPage(),
      '/Signup': (context) => SignupPage(),
      '/Crud': (context) => CrudScreen(),
      '/Maps': (context) => Maps(),
      '/Profile': (context) => ProfilePage(),
      '/Groups': (context) => Groups(),
      '/Search': (context) => SearchPage(),


    },
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
