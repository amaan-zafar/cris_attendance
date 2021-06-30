part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {}

class ImageNotClicked extends CameraState {
  const ImageNotClicked();
  @override
  List<Object> get props => [];
}

class ImageClicked extends CameraState {
  const ImageClicked();
  @override
  List<Object> get props => [];
}

class AttendanceCompleted extends CameraState {
  const AttendanceCompleted();
  @override
  List<Object> get props => [];
}

class EmployeeError extends CameraState {
  final String message;

  const EmployeeError({required this.message});
  @override
  List<Object> get props => [message];
}
