import 'package:cris_attendance/blocs/attendance_slot_bloc/attendance_slot_bloc.dart';
import 'package:cris_attendance/blocs/bloc_observer.dart';
import 'package:cris_attendance/blocs/emp_details_bloc/emp_details_bloc.dart';
import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/network/api_base_helper.dart';
import 'package:cris_attendance/repositories/attendance_slots_repo.dart';
import 'package:cris_attendance/repositories/employee_details_repo.dart';
import 'package:cris_attendance/screens/employee_details.dart';
import 'package:cris_attendance/services/notification.dart';
import 'package:cris_attendance/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  final http.Client _client = http.Client();
  ApiProvider _provider = ApiProvider(httpClient: _client);

  final AttendanceSlotsRepository _slotsRepo =
      AttendanceSlotsRepository(apiProvider: _provider);
  var _slots = _slotsRepo.fetchSlots();

  final EmployeeDetailsRepository _empDetailsRepo =
      EmployeeDetailsRepository(_provider);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ReminderService _reminderService =
      ReminderService(flutterLocalNotificationsPlugin);
  await _reminderService.initialise();
  await _reminderService.scheduledNotif(_slots);

  runApp(MyApp(slots: _slots, empDetailsRepo: _empDetailsRepo));
}

class MyApp extends StatelessWidget {
  final List<AttendanceSlot> slots;
  final EmployeeDetailsRepository empDetailsRepo;
  MyApp({required this.slots, required this.empDetailsRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttendanceSlotBloc(slots),
        ),
        BlocProvider(
          create: (context) => EmpDetailsBloc(empDetailsRepo),
        ),
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
