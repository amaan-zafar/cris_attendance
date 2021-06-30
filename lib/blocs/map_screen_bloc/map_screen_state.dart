part of 'map_screen_bloc.dart';

abstract class MapScreenState extends Equatable {
  const MapScreenState();

  @override
  List<Object> get props => [];
}

class MapScreenInitial extends MapScreenState {}

class LoadingMapScreen extends MapScreenState {
  final String message;

  const LoadingMapScreen({required this.message});
  @override
  List<Object> get props => [message];
}

class MapScreenLoaded extends MapScreenState {
  final String attendanceInfo;

  const MapScreenLoaded({required this.attendanceInfo});
  @override
  List<Object> get props => [attendanceInfo];
}

class MapScreenError extends MapScreenState {
  final String message;

  const MapScreenError({required this.message});
  @override
  List<Object> get props => [message];
}
