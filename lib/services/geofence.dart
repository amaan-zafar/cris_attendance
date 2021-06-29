import 'dart:async';
import 'package:cris_attendance/models/office_geofence.dart';
import 'package:geolocator/geolocator.dart';

enum GeofenceEvent { inside, outside }

class Geofence {
  /// Parser method which is basically for parsing [String] values
  /// to [double] values
  static double _parser(String value) {
    return double.parse(value);
  }

  static Future<OfficeGeofence> getGeofenceStatus(
      {required OfficeGeofence officeGeofence,
      required Position position}) async {
    double latitude = _parser(officeGeofence.lat);
    double longitude = _parser(officeGeofence.lng);
    double radiusInMeter = _parser(officeGeofence.radInMtrs);

    double distanceInMeters = Geolocator.distanceBetween(
        latitude, longitude, position.latitude, position.longitude);
    print('dist is $distanceInMeters');
    print('radius is $radiusInMeter');
    if (_checkGeofence(distanceInMeters, radiusInMeter) == GeofenceEvent.inside)
      officeGeofence.distanceFromCurrentLocation = distanceInMeters;
    return officeGeofence;
  }

  static GeofenceEvent _checkGeofence(
      double distanceInMeters, double radiusInMeter) {
    if (distanceInMeters <= radiusInMeter) {
      return (GeofenceEvent.inside);
    } else {
      return (GeofenceEvent.outside);
    }
  }
}
