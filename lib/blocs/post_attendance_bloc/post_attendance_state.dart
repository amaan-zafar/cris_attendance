part of 'post_attendance_bloc.dart';

abstract class PostAttendanceState extends Equatable {
  const PostAttendanceState();

  @override
  List<Object> get props => [];
}

class PostAttendanceInitial extends PostAttendanceState {}

class Loading extends PostAttendanceState {
  final String message;

  const Loading({required this.message});
  @override
  List<Object> get props => [message];
}

class EmployeeLoaded extends PostAttendanceState {
  final Employee employee;

  const EmployeeLoaded({required this.employee});
  @override
  List<Object> get props => [employee];
}

class Error extends PostAttendanceState {
  final String message;

  const Error({required this.message});
  @override
  List<Object> get props => [message];
}
