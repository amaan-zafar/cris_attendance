part of 'emp_details_bloc.dart';

abstract class EmpDetailsState extends Equatable {
  const EmpDetailsState();

  @override
  List<Object> get props => [];
}

class EmpDetailsInitial extends EmpDetailsState {}

class EmployeeLoading extends EmpDetailsState {
  final String message;

  const EmployeeLoading({required this.message});
  @override
  List<Object> get props => [message];
}

class EmployeeLoaded extends EmpDetailsState {
  final Employee employee;

  const EmployeeLoaded({required this.employee});
  @override
  List<Object> get props => [employee];
}

class EmployeeError extends EmpDetailsState {
  final String message;

  const EmployeeError({required this.message});
  @override
  List<Object> get props => [message];
}
