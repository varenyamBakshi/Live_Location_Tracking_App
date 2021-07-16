import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Signup.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  String _email = '', _password = '';
  bool _showPassword = true;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/Groups");
        //Navigator.pushReplacementNamed(context, "/Home");

      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushReplacementNamed(context, "/Groups");
        //Navigator.pushReplacementNamed(context, "/Home");
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
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
  //
  // navigateToSignUp() async {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
              SizedBox(height: 120.0),
              Text('LOGIN',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 48.0,
                      color: Colors.white)),
              SizedBox(height: 10.0),
              Divider(),
              CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-H5Zr1VJQqLqotQUd24-1gB9ALlspKcqbtA&usqp=CAU'),
              ),
              // Container(
              //   child: ButtonTheme(
              //     child: SignInButton(
              //       Buttons.Google,
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
                                  focusColor: Color(0xffBB86FC),
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
                                        width: 1, color: Color(0xffBB86FC)),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              obscureText: _showPassword,
                              onSaved: (input) => _password = input!,
                            )),
                        SizedBox(height: 20.0),
                        FlatButton(
                          onPressed: login,
                          color: Color(0xffBB86FC),
                          child: Text('Sign In',
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                        ),
                        SizedBox(height: 10.0),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 20.0,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new SignupPage()));
                                    //this.checkAuthentication();
                                  })
                          ]),
                        ),
                      ])))
            ]),
          ),
        ),
      ),
      backgroundColor: Color(0xff121212),
    ));
  }
}
