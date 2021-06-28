import 'package:cris_attendance/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String KolkataTZ = 'Asia/Kolkata';

class ReminderService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  ReminderService(this._flutterLocalNotificationsPlugin);
  String? selectedNotificationPayload;

  // Initialise
  Future initialise() async {
    await _configureLocalTimeZone();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.payload;
      print('Selected Payload on applaunch is $selectedNotificationPayload');
    }

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(KolkataTZ));
    print('Timezone is ${tz.local}');
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => MapScreen(currentPosition: currentPosition)(payload)),
    // );
  }

  Future instantNotif() async {
    var android = AndroidNotificationDetails('id', 'Channel', 'Desc');
    var platform = NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.show(
        0, 'Demo instant notif', 'Mark attendance', platform,
        payload: "Welcom");
  }

  Future scheduledNotif() async {
    print('Scheduling notif');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Mark Attendance',
        'Mark your attendance for Time Slot 1 at This Office',
        _nextInstanceOfDateTime(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'Attendance Notification Channel Id',
                'Attendance Notification Channel name',
                'Attendance Notification desc')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  tz.TZDateTime _nextInstanceOfDateTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    int hour;
    int min;
    if (now.isBefore(DateTime(now.year, now.month, now.day, 2, 20))) {
      hour = 2;
      min = 20;
    } else if (now.isBefore(DateTime(now.year, now.month, now.day, 12))) {
      hour = 12;
      min = 0;
    } else if (now.isBefore(DateTime(now.year, now.month, now.day, 15))) {
      hour = 15;
      min = 0;
    } else {
      hour = 9;
      min = 0;
    }
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min);

    // When scheduled date is past, update the scheduled date
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if (scheduledDate.weekday == DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print('scheduled date time is $scheduledDate');
    return scheduledDate;
  }
}
