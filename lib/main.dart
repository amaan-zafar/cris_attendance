import 'package:cris_attendance/blocs/bloc_observer.dart';
import 'package:cris_attendance/blocs/emp_details_bloc/emp_details_bloc.dart';
import 'package:cris_attendance/blocs/map_screen_bloc/map_screen_bloc.dart';
import 'package:cris_attendance/network/api_base_helper.dart';
import 'package:cris_attendance/repositories/attendance_slots_repo.dart';
import 'package:cris_attendance/repositories/employee_details_repo.dart';
import 'package:cris_attendance/repositories/post_attendance_repo.dart';
import 'package:cris_attendance/screens/employee_details.dart';
import 'package:cris_attendance/services/notification.dart';
import 'package:cris_attendance/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:cris_attendance/globals/globals.dart' as globals;

import 'blocs/post_attendance_bloc/post_attendance_bloc.dart';

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  final http.Client _client = http.Client();
  ApiProvider _provider = ApiProvider(httpClient: _client);

  final AttendanceSlotsRepository _slotsRepo =
      AttendanceSlotsRepository(apiProvider: _provider);
  globals.attendanceSlots = _slotsRepo.fetchSlots();

  final EmployeeDetailsRepository _empDetailsRepo =
      EmployeeDetailsRepository(_provider);

  final PostAttendancerepo _postAttendRepo = PostAttendancerepo(_provider);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ReminderService _reminderService =
      ReminderService(flutterLocalNotificationsPlugin);
  await _reminderService.initialise();
  await _reminderService.scheduledNotif(globals.attendanceSlots);

  runApp(MyApp(
    empDetailsRepo: _empDetailsRepo,
    postAttendancerepo: _postAttendRepo,
  ));
}

class MyApp extends StatelessWidget {
  final EmployeeDetailsRepository empDetailsRepo;
  final PostAttendancerepo postAttendancerepo;
  MyApp({required this.empDetailsRepo, required this.postAttendancerepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EmpDetailsBloc(empDetailsRepo)),
        BlocProvider(create: (context) => MapScreenBloc()),
        BlocProvider(
            create: (context) => PostAttendanceBloc(postAttendancerepo)),
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
