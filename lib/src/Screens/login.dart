import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'studentDashboard.dart';
import 'teacherDashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _emailValidator = false;
  bool _nullValidator = false;

  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool teacherCheck = false;
  bool teacherSignIn() {
    FirebaseFirestore.instance
        .collection('teacher')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        if (doc["email"] == _email.text && doc["password"] == _pass.text) {
          teacherCheck = true;
        }
      });
    });
    return teacherCheck;
  }

  bool studentCheck = false;
  bool studentSignIn() {
    FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        if (doc["email"] == _email.text && doc["password"] == _pass.text) {
          studentCheck = true;
        }
      });
    });
    return studentCheck;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                    radius: 70),
              ),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      //Email
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
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
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print(teacherSignIn());
                            if (teacherSignIn()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherDashboard()));
                            } else if (studentSignIn()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentDashboard()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Wrong!!!')));
                            }
                          }
                        },
                        child: Text('Sign In'))
                  ])),
              Container(
                //ForgotPassword
                child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Forgot Password'),
                            content: TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                  labelText: 'Enter registered email',
                                  errorText: _nullValidator
                                      ? 'Please Enter some text'
                                      : _emailValidator
                                          ? 'Invalid email'
                                          : 'All cool'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_email.text.isEmpty) {
                                    print(_email.text);
                                    _nullValidator = true;
                                  } else if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(_email.text)) {
                                    print(_email.text);
                                    _emailValidator = true;
                                  } else {
                                    _nullValidator = false;
                                    _emailValidator = false;
                                    Navigator.pop(context, 'OK');
                                  }
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          )),
                  child: Text('Forgot Password'),
                ),
              ),
              Container(
                child: TextButton(
                  onPressed: () {},
                  child: Text('If you don\'t have an account click here'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
