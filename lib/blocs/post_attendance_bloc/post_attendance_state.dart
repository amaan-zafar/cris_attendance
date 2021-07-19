part of 'post_attendance_bloc.dart';

abstract class PostAttendanceState extends Equatable {
  const PostAttendanceState();

  @override
  List<Object> get props => [];
}

class PostAttendanceInitial extends PostAttendanceState {}

class PostAttendanceLoading extends PostAttendanceState {
  final String message;

  const PostAttendanceLoading({required this.message});
  @override
  List<Object> get props => [message];
}

class AttendanceCompleted extends PostAttendanceState {
  final Response response;

  AttendanceCompleted(this.response);

  @override
  List<Object> get props => [response];
}

class PostAttendanceError extends PostAttendanceState {
  final String message;

  const PostAttendanceError({required this.message});
  @override
  List<Object> get props => [message];
}
