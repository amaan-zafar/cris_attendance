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
      try {
        String slotInfo, officeInfo;
        bool canMark;
        AttendanceSlot? currentSlot = _getCurrentSlot();
        slotInfo = currentSlot != null
            ? '${currentSlot.startTime.hour}:${currentSlot.startTime.minute}-${currentSlot.endTime.hour}:${currentSlot.endTime.minute}'
            : 'Time Window Closed';
        final OfficeGeofence? targetOffice =
            await _getTargetOffice(globals.offices, event.currentPosition);
        officeInfo = targetOffice != null
            ? '${targetOffice.officeName} [${targetOffice.distanceFromCurrentLocation!.toStringAsFixed(2)}meters]'
            : 'Not with any CRIS office geofence';
        canMark = currentSlot != null || targetOffice != null ? true : false;
        yield MapScreenLoaded(
            officeInfo: officeInfo, slotInfo: slotInfo, canMark: canMark);
      } catch (e) {
        MapScreenError(
            message: 'Error in getting target office: ${e.toString()}');
      }
    }
  }

  Future<OfficeGeofence?> _getTargetOffice(
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

  AttendanceSlot? _getCurrentSlot() {
    DateTime now = DateTime.now();
    AttendanceSlot? currentSlot;
    globals.attendanceSlots.forEach((element) {
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
