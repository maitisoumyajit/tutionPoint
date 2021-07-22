import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

//after this all for references
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tution Point',
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('TutionPoint'),
          ),
          body: LoginPage(),
        ));
  }
}

//LoginPage
class LoginPage extends StatefulWidget {
  //LoginPage({Key? key, required this.title}) : super(key: key);

  //final String title;

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

//Registration Page
class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _mobileNo = TextEditingController();

  void dispose() {
    _pass.dispose();
    _name.dispose();
    _email.dispose();
    _mobileNo.dispose();
    super.dispose();
  }

  CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  Future<void> addTeacher() {
    return teacher
        .add({
          'full name': _name.text,
          'email': _email.text,
          'password': _pass.text,
          'mobile number': _mobileNo.text
        })
        .then((value) => print('Added : ${value}'))
        // .then((value) => Fluttertoast.showToast(
        //       msg: 'User Registered Successfully!!',
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.CENTER,
        //     ))

        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
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
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text('User Regitered Successfully!! ')));
                        }
                      },
                      child: Text('Sign Up'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Teacher Dashboard
class TeacherDashboard extends StatefulWidget {
  //TeacherDashboard({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  _TeacherDashBoardState createState() => _TeacherDashBoardState();
}

class _TeacherDashBoardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                'Dashboard',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Add Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'View Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Student Report',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Assignment',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Class/Study Meterials',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                  Container(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Fees',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size(100, 100)),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Add Student
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

  Future<void> addStudent() {
    return students
        .add({
          'full name': _studentName.text,
          'email': _studentEmail.text,
          'mobile no': _studentMobileNo.text,
          'course or class name': _studentCourseName.text,
          'school or college name': _studentSchoolName.text,
          'gender': _gender.toString(),
          'password': '12345'
        })
        .then((value) => print('student added'))
        .catchError((error) => print('Somthing happend -> ${error}'));
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

//View Student Profile

//Student Report

//Assignment

//Class Schedule

//Fees

//Teacher Profile

//Student Dashboard
class StudentDashboard extends StatefulWidget {
  //final String title;
  //StudentDashboard({Key? key, required this.title}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Icon(Icons.logout),
      onPressed: () {},
    ));
  }
}

//First Time Page (One Time) Change Password

//Join lecture

//Assignment

//Fees

//Class Matirials

//Student Profile
