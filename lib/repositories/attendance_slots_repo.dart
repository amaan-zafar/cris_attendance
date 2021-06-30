import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/network/api_base_helper.dart';
import 'package:flutter/material.dart';

class AttendanceSlotsRepository {
  final ApiProvider apiProvider;
  AttendanceSlotsRepository({required this.apiProvider});
  // Future<List<AttendanceSlot>> fetchStandings() async {
  //   final response = await apiProvider.get('slots');
  //   return AttendanceSlot.fromJson(response);
  // }

  List<AttendanceSlot> fetchSlots() {
    // final response = await apiProvider.get('slots');
    return [
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
          startTime: TimeOfDay(hour: 15, minute: 0),
          endTime: TimeOfDay(hour: 15, minute: 30)),
    ];
  }
}
