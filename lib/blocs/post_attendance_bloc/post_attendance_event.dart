part of 'post_attendance_bloc.dart';

abstract class PostAttendanceEvent extends Equatable {
  const PostAttendanceEvent();

  @override
  List<Object> get props => [];
}

class PostAttendance extends PostAttendanceEvent {
  final PostAttendanceModel attendanceModel;
  const PostAttendance({required this.attendanceModel});
  @override
  List<Object> get props => [attendanceModel];
}
