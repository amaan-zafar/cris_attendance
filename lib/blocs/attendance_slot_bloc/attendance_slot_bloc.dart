import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:equatable/equatable.dart';

part 'attendance_slot_event.dart';
part 'attendance_slot_state.dart';

class AttendanceSlotBloc
    extends Bloc<AttendanceSlotEvent, AttendanceSlotState> {
  final List<AttendanceSlot> slots;
  AttendanceSlotBloc(this.slots) : super(AttendanceSlotInitial());

  @override
  Stream<AttendanceSlotState> mapEventToState(
    AttendanceSlotEvent event,
  ) async* {
    DateTime now = DateTime.now();
    AttendanceSlot nextSlot = slots.firstWhere((element) {
      DateTime startTime = DateTime(now.year, now.month, now.day,
          element.startTime.hour, element.endTime.minute);
      return now.isBefore(startTime);
    });
    if (event is GetSlots) {
      yield AttendanceSlotLoaded(slot: nextSlot);
    }
  }
}
