import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/models/post_attendance.dart';
import 'package:cris_attendance/repositories/post_attendance_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'post_attendance_event.dart';
part 'post_attendance_state.dart';

class PostAttendanceBloc
    extends Bloc<PostAttendanceEvent, PostAttendanceState> {
  final PostAttendancerepo _postAttendancerepo;
  PostAttendanceBloc(this._postAttendancerepo) : super(PostAttendanceInitial());

  @override
  Stream<PostAttendanceState> mapEventToState(
    PostAttendanceEvent event,
  ) async* {
    if (event is PostAttendance) {
      yield PostAttendanceLoading(message: 'Marking attendance...');
      try {
        final response =
            await _postAttendancerepo.postAttendance(event.attendanceModel);
        yield AttendanceCompleted(response);
      } catch (e) {
        yield PostAttendanceError(
            message: 'Error in posting attendance. ${e.toString()}');
      }
    }
  }
}
