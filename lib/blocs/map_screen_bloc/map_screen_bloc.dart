import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/models/office_geofence.dart';
import 'package:cris_attendance/services/geofence.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cris_attendance/globals/globals.dart' as globals;

part 'map_screen_event.dart';
part 'map_screen_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  MapScreenBloc() : super(MapScreenInitial());

  @override
  Stream<MapScreenState> mapEventToState(
    MapScreenEvent event,
  ) async* {
    if (event is LoadMapScreen) {
      yield LoadingMapScreen(message: 'Loading geofences...');
      String attendanceInfo =
          'You can only mark attendance from a CRIS Office.\n[All CRIS offices are shown with markers on the Google Map.]';
    }
  }

  Future<OfficeGeofence?> getTargetOffice(
      List<OfficeGeofence> offices, Position position) async {
    List<OfficeGeofence> insideOffices = [];
    for (var office in offices) {
      OfficeGeofence returnedOffice = await Geofence.getGeofenceStatus(
          officeGeofence: office, position: position);
      if (returnedOffice.distanceFromCurrentLocation != null)
        insideOffices.add(returnedOffice);
    }

    OfficeGeofence? minDistOffice;
    if (insideOffices.isNotEmpty) {
      minDistOffice = insideOffices[0];
      double minDist = insideOffices[0].distanceFromCurrentLocation!;
      insideOffices.forEach((element) {
        if (element.distanceFromCurrentLocation! < minDist) {
          minDist = element.distanceFromCurrentLocation!;
          minDistOffice = element;
        }
      });
    }
    return minDistOffice;
  }

  AttendanceSlot? getCurrentSlot() {
    DateTime now = DateTime.now();
    AttendanceSlot? currentSlot;
    globals.attendanceSlots!.forEach((element) {
      DateTime startTime = DateTime(now.year, now.month, now.day,
          element.startTime.hour, element.startTime.minute);
      DateTime endTime = DateTime(now.year, now.month, now.day,
          element.endTime.hour, element.endTime.minute);
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        currentSlot = element;
      }
    });
    return currentSlot;
  }
}
