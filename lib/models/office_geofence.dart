class OfficeGeofence {
  String officeName;
  String lat;
  String lng;
  String radInMtrs;
  double? distanceFromCurrentLocation;

  OfficeGeofence(
      {required this.officeName,
      required this.lat,
      required this.lng,
      required this.radInMtrs});
}
