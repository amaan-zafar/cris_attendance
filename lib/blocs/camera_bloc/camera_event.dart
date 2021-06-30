part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class ClickImage extends CameraEvent {
  @override
  List<Object> get props => [];
}

class SaveImage extends CameraEvent {
  @override
  List<Object> get props => [];
}

class CompleteAttendance extends CameraEvent {
  @override
  List<Object> get props => [];
}
