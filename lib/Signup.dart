import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'Crud.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  void _showButtonPressDialog(BuildContext context, String provider) {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$provider Button Pressed!'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 400),
    ));
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '', _password = '', _username = '';
  bool _showPassword = true;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null && user.displayName != null) {
        Navigator.pushReplacementNamed(context, "/Groups");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    Position geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential user = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((value) async {
          // UserUpdateInfo updateuser = UserUpdateInfo();
          // updateuser.displayName = _name;
          //  user.updateProfile(updateuser);
          await _auth.currentUser!.updateDisplayName(_username);
          // await Navigator.pushReplacementNamed(context,"/") ;

          return value;
        });

        //adding this user information to "data" collection

        Crud newUser = new Crud();
        await newUser.addUser(loc: geoposition);
        await newUser.updateData(full_name: _username);
      } catch (e) {
        showError(e.toString());
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            SizedBox(height: 120),
            Text('SIGN UP',
                style: TextStyle(
                    fontFamily: 'Roboto', fontSize: 48.0, color: Colors.white)),
            SizedBox(height: 10.0),
            Divider(),
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/images.png'),
            ),
            // Container(
            //   child: ButtonTheme(
            //     child: SignInButton(
            //       Buttons.Google,
            //       text: 'Sign up with Google',
            //       onPressed: () {
            //         _showButtonPressDialog(context, 'Google');
            //       },
            //     ),
            //     height: 48.0,
            //     minWidth: 300.0,
            //   ),
            // ),
            Container(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (input) {
                              if (input!.isEmpty) return 'Enter Username';
                            },
                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: Colors.white38,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            onSaved: (input) => _username = input!,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (input) {
                              if (input!.isEmpty) return 'Enter E-mail';
                            },
                            decoration: InputDecoration(
                                labelText: 'Email Id',
                                labelStyle: TextStyle(
                                  color: Colors.white38,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            onSaved: (input) => _email = input!,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (input) {
                              if (input!.length < 6)
                                return 'Password must be at least 6 characters';
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _togglevisibility();
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white38,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white38,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            obscureText: _showPassword,
                            onSaved: (input) => _password = input!,
                          )),
                      SizedBox(height: 20.0),
                      FlatButton(
                        onPressed: signUp,
                        color: Color(0xffBB86FC),
                        child: Text('Sign Up',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                      )
                    ]))),
            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Login',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20.0,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacementNamed(context, "/Login");
                        //this.checkAuthentication();
                      })
              ]),
            ),
          ]),
        ),
      ),
      backgroundColor: Color(0xff121212),
    ));
  }
}
