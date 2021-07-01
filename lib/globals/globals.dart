library cris_attendance.globals;

import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/models/office_geofence.dart';
import 'package:flutter/material.dart';

List<AttendanceSlot> attendanceSlots = [
  AttendanceSlot(
      slotNumber: 1,
      status: AttendanceStatus.NotMarked,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30)),
  AttendanceSlot(
      slotNumber: 2,
      status: AttendanceStatus.NotMarked,
      startTime: TimeOfDay(hour: 12, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 30)),
  AttendanceSlot(
      slotNumber: 3,
      status: AttendanceStatus.NotMarked,
      startTime: TimeOfDay(hour: 15, minute: 30),
      endTime: TimeOfDay(hour: 16, minute: 30)),
];

List<OfficeGeofence> offices = [
  OfficeGeofence(
      officeName: "CRIS Office 1",
      lat: "25.58790",
      lng: "85.09500",
      radInMtrs: "80"),
  OfficeGeofence(
      officeName: "CRIS Office 2",
      lat: "25.585381090862434",
      lng: "85.09535758698132",
      radInMtrs: "100"),
  OfficeGeofence(
      officeName: "CRIS Office 3",
      lat: "25.582476691908993",
      lng: "85.09496933762402",
      radInMtrs: "100"),
];
