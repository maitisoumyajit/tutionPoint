import 'package:tution_point/main.dart';

//import 'Screens/login.dart';
//import 'Screens/registration.dart';
//import 'Screens/teacherDashboard.dart';
//import 'Screens/addStudent.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tution Point',
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('TutionPoint'),
          ),
          body: AddStudent(),
        ));
  }
}
