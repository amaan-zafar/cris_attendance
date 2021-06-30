import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String KolkataTZ = 'Asia/Kolkata';

class ReminderService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  ReminderService(this._flutterLocalNotificationsPlugin);
  String? selectedNotificationPayload;

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
  }

  // Future instantNotif() async {
  //   var android = AndroidNotificationDetails('id', 'Channel', 'Desc');
  //   var platform = NotificationDetails(android: android);
  //   await _flutterLocalNotificationsPlugin.show(
  //       0, 'Demo instant notif', 'Mark attendance', platform,
  //       payload: "Welcom");
  // }

  Future scheduledNotif(List<AttendanceSlot> slots) async {
    final DateTime now = DateTime.now();
    print('Now time is $now');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Mark your Attendance',
        "It's time to mark your attendance",
        _nextInstanceOfDateTime(now, slots),
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

  tz.TZDateTime _nextInstanceOfDateTime(
      DateTime now, List<AttendanceSlot> slots) {
    tz.TZDateTime scheduledDateTime = tz.TZDateTime(tz.local, now.year,
        now.month, now.day, slots[0].startTime.hour, slots[0].startTime.minute);

    AttendanceSlot nextSlot = slots.firstWhere((element) {
      tz.TZDateTime startTime = tz.TZDateTime(tz.local, now.year, now.month,
          now.day, element.startTime.hour, element.startTime.minute);
      if (now.isBefore(startTime)) {
        scheduledDateTime = startTime;
        return true;
      } else {
        return false;
      }
    }, orElse: () {
      scheduledDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          slots[0].startTime.hour, slots[0].startTime.minute);
      return slots[0];
    });

    // When scheduled date is past, update the scheduled date
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }
    if (scheduledDateTime.weekday == DateTime.sunday) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }
    print('scheduled date time is $scheduledDateTime');
    return scheduledDateTime;
  }
}
