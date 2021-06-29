import 'package:flutter/material.dart';

enum AttendanceStatus { NotMarked, Marked, Absent }

class AttendanceSlot {
  int slotNumber;
  AttendanceStatus status;
  TimeOfDay startTime;
  TimeOfDay endTime;

  AttendanceSlot(
      {required this.slotNumber,
      required this.status,
      required this.startTime,
      required this.endTime});
}
