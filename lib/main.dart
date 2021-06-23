import 'package:cris_attendance/blocs/bloc_observer.dart';
import 'package:cris_attendance/screens/employee_details.dart';
import 'package:cris_attendance/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRIS Attendance',
        theme: AppTheme.theme,
        home: EmployeeDetailsScreen(),
      ),
    );
  }
}
