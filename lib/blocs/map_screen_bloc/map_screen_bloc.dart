import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_screen_event.dart';
part 'map_screen_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  MapScreenBloc() : super(MapScreenInitial());

  @override
  Stream<MapScreenState> mapEventToState(
    MapScreenEvent event,
  ) async* {
    if (event is LoadMapScreen) {
      yield LoadingMapScreen(message: 'Loading Geofences...');
      try {} catch (e) {
        yield MapScreenError(message: '${e.toString()}');
      }
    }
  }
}
