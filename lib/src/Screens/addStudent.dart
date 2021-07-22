import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tution_point/main.dart';

class AddStudent extends StatefulWidget {
  // AddStudent({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  _AddStudentState createState() => _AddStudentState();
}

enum genderCharecter { male, female, others }

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  genderCharecter? _gender = genderCharecter.female;

  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _studentEmail = TextEditingController();
  final TextEditingController _studentMobileNo = TextEditingController();
  final TextEditingController _studentCourseName = TextEditingController();
  final TextEditingController _studentSchoolName = TextEditingController();

  void dispose() {
    _studentName.dispose();
    _studentEmail.dispose();
    _studentMobileNo.dispose();
    _studentCourseName.dispose();
    _studentSchoolName.dispose();
    super.dispose();
  }

  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  void createStudntDocument() {
    students
        .add({
          'email': _studentEmail.text.trim(),
          'name': _studentName.text.trim(),
          'mobile-no': _studentMobileNo.text.trim(),
          'gender': _gender,
          'course-name': _studentCourseName,
          'school-name': _studentSchoolName,
          'time-Stamp': DateTime.now().toString().trim()
        })
        .then((value) => Fluttertoast.showToast(
              msg: "123Student added successfully!!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0,
            ))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print(error));
  }

  Future<void> addStudent() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _studentEmail.text.trim(), password: 'Password@123');

      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

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
                  controller: _studentName,
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
                  controller: _studentEmail,
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
                  //Mobile Number
                  controller: _studentMobileNo,
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
                TextFormField(
                  //Class/Course
                  controller: _studentCourseName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Course/Class Name'),
                ),
                TextFormField(
                  //School/College
                  controller: _studentSchoolName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'College/School Name'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListTile(
                    title: Text('Female'),
                    leading: Radio<genderCharecter>(
                      value: genderCharecter.female,
                      groupValue: _gender,
                      onChanged: (genderCharecter? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    )),
                ListTile(
                    title: Text('Male'),
                    leading: Radio<genderCharecter>(
                      value: genderCharecter.male,
                      groupValue: _gender,
                      onChanged: (genderCharecter? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    )),
                ListTile(
                    title: Text('Others'),
                    leading: Radio<genderCharecter>(
                      value: genderCharecter.others,
                      groupValue: _gender,
                      onChanged: (genderCharecter? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    )),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addStudent();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text('Submitted')));
                      }
                    },
                    child: Text('Add Student'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
