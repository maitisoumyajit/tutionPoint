import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherDashboard extends StatefulWidget {
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
