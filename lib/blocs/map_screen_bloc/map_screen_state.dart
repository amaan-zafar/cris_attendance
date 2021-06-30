part of 'map_screen_bloc.dart';

abstract class MapScreenState extends Equatable {
  const MapScreenState();
  
  @override
  List<Object> get props => [];
}

class MapScreenInitial extends MapScreenState {}
