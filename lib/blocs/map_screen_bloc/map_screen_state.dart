part of 'map_screen_bloc.dart';

abstract class MapScreenState extends Equatable {
  const MapScreenState();

  @override
  List<Object> get props => [];
}

class MapScreenInitial extends MapScreenState {}

class MapScreenError extends MapScreenState {
  final String message;

  const MapScreenError({required this.message});
  @override
  List<Object> get props => [message];
}
