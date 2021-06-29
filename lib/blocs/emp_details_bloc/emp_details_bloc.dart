import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/repositories/employee_details_repo.dart';
import 'package:equatable/equatable.dart';

part 'emp_details_event.dart';
part 'emp_details_state.dart';

class EmpDetailsBloc extends Bloc<EmpDetailsEvent, EmpDetailsState> {
  final EmployeeDetailsRepository _employeeDetailsRepository;

  EmpDetailsBloc(this._employeeDetailsRepository) : super(EmpDetailsInitial());

  @override
  Stream<EmpDetailsState> mapEventToState(
    EmpDetailsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
