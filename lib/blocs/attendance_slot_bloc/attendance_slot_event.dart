part of 'attendance_slot_bloc.dart';

abstract class AttendanceSlotEvent extends Equatable {
  const AttendanceSlotEvent();

  @override
  List<Object> get props => [];
}

class GetSlots extends AttendanceSlotEvent {
  final String leagueCode;

  GetSlots({required this.leagueCode});
  @override
  List<Object> get props => [];
}
