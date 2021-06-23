import 'dart:async';
import 'package:geolocator/geolocator.dart';

enum GeofenceEvent { initial, inside, outside, error }

class Geofence {
  /// Parser method which is basically for parsing [String] values
  /// to [double] values
  static double _parser(String value) {
    return double.parse(value);
  }

  static Future<GeofenceEvent> getGeofenceStatus(
      {required String pointedLatitude,
      required String pointedLongitude,
      required String radiusMeter,
      required int eventPeriodInSeconds}) async {
    double latitude = _parser(pointedLatitude);
    double longitude = _parser(pointedLongitude);
    double radiusInMeter = _parser(radiusMeter);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: eventPeriodInSeconds));
    double distanceInMeters = Geolocator.distanceBetween(
        latitude, longitude, position.latitude, position.longitude);
    print('dist is $distanceInMeters');
    print('radius is $radiusMeter');
    return _checkGeofence(distanceInMeters, radiusInMeter);
  }

  /// [_checkGeofence] is for checking whether current location is in
  /// or
  /// outside of the geofence area
  /// this takes two parameters which is [double] distanceInMeters
  /// distanceInMeters parameters is basically the calculated distance between
  /// geofence area points and the current location points
  /// radiusInMeter take value in [double] and it's the radius of geofence area in meters
  static GeofenceEvent _checkGeofence(
      double distanceInMeters, double radiusInMeter) {
    if (distanceInMeters <= radiusInMeter) {
      return (GeofenceEvent.inside);
    } else {
      return (GeofenceEvent.outside);
    }
  }
}
