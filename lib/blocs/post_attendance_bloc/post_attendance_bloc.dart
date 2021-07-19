import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/models/employee.dart';
import 'package:equatable/equatable.dart';

part 'post_attendance_event.dart';
part 'post_attendance_state.dart';

class PostAttendanceBloc
    extends Bloc<PostAttendanceEvent, PostAttendanceState> {
  PostAttendanceBloc() : super(PostAttendanceInitial());

  @override
  Stream<PostAttendanceState> mapEventToState(
    PostAttendanceEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
