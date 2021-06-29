part of 'emp_details_bloc.dart';

abstract class EmpDetailsEvent extends Equatable {
  const EmpDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetEmployee extends EmpDetailsEvent {
  GetEmployee();
  @override
  List<Object> get props => [];
}
