import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'teacherDashboard.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _mobileNo = TextEditingController();

  void dispose() {
    _pass.dispose();
    _name.dispose();
    _email.dispose();
    _mobileNo.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  Future<void> addTeacher() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text.trim(),
              password: _pass.text.trimLeft().trimRight());
      print(userCredential);
      teacher
          .add({
            'email': _email.text.trim(),
            'name': _name.text.trim(),
            'mobile-no': _mobileNo.text.trim(),
            'time-Stamp': DateTime.now().toString().trim()
          })
          .then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TeacherDashboard())))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print(error));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);

      //Signin with google
      // Future<UserCredential> signInWithGoogle() async {
      //   // Trigger the authentication flow
      //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //   // Obtain the auth details from the request
      //   final GoogleSignInAuthentication googleAuth =
      //       await googleUser!.authentication;

      //   // Create a new credential
      //   final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth.accessToken,
      //     idToken: googleAuth.idToken,
      //   );

      //   // Once signed in, return the UserCredential
      //   return await FirebaseAuth.instance.signInWithCredential(credential);
      // }
    }

    // return teacher
    //     .add({
    //       'email': _email.text,
    //       'password': _pass.text,
    //     })
    //     .then((value) => print('Added : ${value}'))
    //     // .then((value) => Fluttertoast.showToast(
    //     //       msg: 'User Registered Successfully!!',
    //     //       toastLength: Toast.LENGTH_LONG,
    //     //       gravity: ToastGravity.CENTER,
    //     //     ))

    //     // ignore: invalid_return_type_for_catch_error
    //     .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(7),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Logo.png'),
                      radius: 70),
                ),
                TextFormField(
                  //Name
                  controller: _name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  //Email
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                      return 'Invalid Email!!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  //Password
                  obscureText: true,
                  controller: _pass,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must have 1 upper case letter, 1 lower case letter, 1 numeric value, 1 special charecter';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorMaxLines: 2,
                  ),
                ),
                TextFormField(
                  //Confirm Password
                  controller: _confirmPassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    } else if (value != _pass.text) {
                      return 'Password and confirm password did no match ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                ),
                TextFormField(
                  //Mobile Number
                  controller: _mobileNo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    } else if (!RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return 'Its not a valid mobile number';
                    } else if (value.length != 10) {
                      return 'Mobile number does not contain more or less than 10 digits';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addTeacher();

                        Fluttertoast.showToast(
                          msg: "User registered successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text('Sign Up')),
                SignInButton(Buttons.GoogleDark, onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
