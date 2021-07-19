part of 'post_attendance_bloc.dart';

abstract class PostAttendanceState extends Equatable {
  const PostAttendanceState();
  
  @override
  List<Object> get props => [];
}

class PostAttendanceInitial extends PostAttendanceState {}
