import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './crud.dart';
import 'package:flutter/gestures.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email= '',_username='',_password='';
  Crud crud=new Crud();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {

      Navigator.pushReplacementNamed(context, "/Login");
    }
  });
        }

  // static Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  //   return DialogRoute<void>(
  //     context: context,
  //     builder: (BuildContext context) => {showDialog(child: new Dialog(
  //     child: new Column(
  //     children: <Widget>[
  //     new TextField(
  //     decoration: new InputDecoration(hintText: "Enter Password"),
  //     controller: _c,
  //
  //     ),

  //     ],
  //     ),
  //
  //    ), context: context);
  //
  //


  // }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {

              },
              obscureText: true,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('ENTER'),
                  onPressed: () {
                    _password = _textFieldController.toString();
                    Navigator.pop(context);
                  })
            ],

          );
        });
  }


  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    _email=_auth.currentUser!.email.toString();
    _username=_auth.currentUser!.displayName.toString();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context)=>SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: <Widget>[
                      SizedBox(height: 120.0),
                      Text(
                          'EDIT PROFILE',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 48.0,
                              color: Colors.white

                          )
                      ),
                      SizedBox(height: 170.0),
                      Divider(),
                      Container(
                          child: Form(
                              key: _formKey,
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                                        child: TextFormField(
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          validator: (input)
                                          {
                                            if(input!.isEmpty)
                                              return 'Enter Username';
                                          },
                                          decoration: InputDecoration(
                                              hintText: _username,
                                              hintStyle: TextStyle(
                                                color: Colors.white38,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1, color: Colors.white38),
                                                borderRadius: BorderRadius.circular(8),

                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1, color: Colors.white38),
                                                borderRadius: BorderRadius.circular(8),
                                              )
                                          ),
                                          onc: (input)=> _username=input!,

                                        )
                                    ),
                                    Container(
                                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                                        child: TextFormField(
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          validator: (input)
                                          {
                                            if(input!.isEmpty)
                                              return 'Enter E-mail';
                                          },
                                          decoration: InputDecoration(

                                              hintText: _email,
                                              hintStyle: TextStyle(
                                                color: Colors.white38,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1, color: Colors.white38),
                                                borderRadius: BorderRadius.circular(8),

                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1, color: Colors.white38),
                                                borderRadius: BorderRadius.circular(8),
                                              )
                                          ),
                                          onSaved: (input)=> _email=input!,

                                        )
                                    ),

                                    SizedBox(height: 20.0),
                                    FlatButton(
                                      onPressed: ()=>{crud.updateData(full_name:_username,email:_email)},
                                      color: Color(0xffBB86FC),
                                      child: Text(
                                          'Update',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )
                                      ),


                                    ),
                                    SizedBox(height: 10.0),
                                    FlatButton(

                                        onPressed: () async {
                                          //Navigator.of(context).restorablePush(_dialogBuilder);
                                          _displayTextInputDialog(context);

                                          if(_password!="") {
                                            String email = _auth.currentUser!.email.toString();



                                            AuthCredential credential = EmailAuthProvider.credential(email: email, password: _password);


                                            FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
                                            crud.deleteUser();

                                          }
                                        },


                                      color: Color(0xffBB86FC),
                                      child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )
                                      ),


                                    ),
                                  ]
                              )
                          )
                      )



                    ]
                ),
              ),
            ),
          ),

          backgroundColor: Color(0xff121212),
        )
    );
  }
}
