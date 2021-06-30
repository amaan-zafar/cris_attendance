part of 'map_screen_bloc.dart';

abstract class MapScreenEvent extends Equatable {
  const MapScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadMapScreen extends MapScreenEvent {
  const LoadMapScreen(this.currentPosition);
  final Position currentPosition;
  @override
  List<Object> get props => [currentPosition];
}
