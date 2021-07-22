import 'package:flutter/material.dart';

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
