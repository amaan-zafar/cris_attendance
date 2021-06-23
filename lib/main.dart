import 'package:cris_attendance/screens/employee_details.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRIS Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeeDetailsScreen(),
    );
  }
}
