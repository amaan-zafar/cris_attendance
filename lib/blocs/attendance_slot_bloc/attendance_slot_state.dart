part of 'attendance_slot_bloc.dart';

abstract class AttendanceSlotState extends Equatable {
  const AttendanceSlotState();

  @override
  List<Object> get props => [];
}

class AttendanceSlotInitial extends AttendanceSlotState {}

class AttendanceSlotLoading extends AttendanceSlotState {
  final String message;

  const AttendanceSlotLoading({required this.message});
  @override
  List<Object> get props => [message];
}

class AttendanceSlotLoaded extends AttendanceSlotState {
  final AttendanceSlot slot;

  const AttendanceSlotLoaded({required this.slot});
  @override
  List<Object> get props => [slot];
}

class AttendanceSlotError extends AttendanceSlotState {
  final String message;

  const AttendanceSlotError({required this.message});
  @override
  List<Object> get props => [message];
}
