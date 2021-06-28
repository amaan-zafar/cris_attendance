import 'package:cris_attendance/blocs/bloc_observer.dart';
import 'package:cris_attendance/screens/employee_details.dart';
import 'package:cris_attendance/services/notification.dart';
import 'package:cris_attendance/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = SimpleBlocObserver();
  ReminderService _reminderService =
      ReminderService(flutterLocalNotificationsPlugin);
  await _reminderService.initialise();
  await _reminderService.scheduledNotif();
  runApp(MyApp(_reminderService));
}

class MyApp extends StatelessWidget {
  final ReminderService _reminderService;
  MyApp(this._reminderService);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRIS Attendance',
      theme: AppTheme.theme,
      home: EmployeeDetailsScreen(),
    );
  }
}
