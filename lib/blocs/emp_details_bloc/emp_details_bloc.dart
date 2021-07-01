import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/models/employee.dart';
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
    if (event is GetEmployee) {
      yield EmployeeLoading(message: 'Loading employee details...');
      try {
        final Employee employee =
            await _employeeDetailsRepository.fetchEmpDetails();
        yield EmployeeLoaded(employee: employee);
      } catch (e) {
        yield EmployeeError(
            message: 'Error in fetching employee details. ${e.toString()}');
        // yield EmployeeLoaded(employee: Employee(firstName: 'Aneesh', lastName: 'Ballabh', email: 'aneesh@gmail.com', dateOfBirth: '15-06-2000', empID: 2019, gender: 'male'));
      }
    }
  }
}
