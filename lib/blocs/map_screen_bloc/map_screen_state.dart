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
  final int? slotNum;
  final String officeInfo;
  final String slotInfo;
  final bool canMark;

  const MapScreenLoaded(
      {required this.officeInfo,
      required this.slotInfo,
      required this.canMark,
      this.slotNum});
  @override
  List<Object> get props => [officeInfo, slotInfo, canMark];
}

class MapScreenError extends MapScreenState {
  final String message;

  const MapScreenError({required this.message});
  @override
  List<Object> get props => [message];
}
