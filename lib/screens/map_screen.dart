import 'dart:async';

import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/models/office_geofence.dart';
import 'package:cris_attendance/screens/camera_screen.dart';
import 'package:cris_attendance/services/geofence.dart';
import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Position currentPosition;
  MapScreen({Key? key, required this.currentPosition}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  List<OfficeGeofence> _offices = [
    OfficeGeofence(
        officeName: "Office 1",
        lat: "25.58790",
        lng: "85.09500",
        radInMtrs: "80"),
    OfficeGeofence(
        officeName: "Office 2",
        lat: "25.585381090862434",
        lng: "85.09535758698132",
        radInMtrs: "100"),
    OfficeGeofence(
        officeName: "Office 3",
        lat: "25.582476691908993",
        lng: "85.09496933762402",
        radInMtrs: "100"),
  ];

  List<AttendanceSlot> slots = [
    AttendanceSlot(
        slotNumber: 1,
        status: AttendanceStatus.NotMarked,
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 9, minute: 30)),
    AttendanceSlot(
        slotNumber: 2,
        status: AttendanceStatus.NotMarked,
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 30)),
    AttendanceSlot(
        slotNumber: 3,
        status: AttendanceStatus.NotMarked,
        startTime: TimeOfDay(hour: 15, minute: 0),
        endTime: TimeOfDay(hour: 15, minute: 30)),
  ];

  AttendanceSlot? currentSlot;
  OfficeGeofence? targetOffice;

  Set<Marker> _markers = {};

  Set<Circle> _circles = {};

  bool _isVisible = false;

  bool _isLoading = true;

  String attendanceInfo =
      'You can only mark attendance from a CRIS Office.\n[All CRIS offices are shown with markers on the Google Map.]';

  @override
  void initState() {
    currentSlot = getCurrentSlot(slots);
    getTargetOffice(_offices).then((value) {
      targetOffice = value;
      print('Office is $targetOffice and slot is $currentSlot');
      _isVisible = currentSlot != null && targetOffice != null ? true : false;
      print('bool is $_isVisible');
      if (targetOffice != null && currentSlot != null) {
        attendanceInfo =
            'Mark your attendance at ${targetOffice!.officeName} for time slot [${currentSlot!.startTime.hour}:${currentSlot!.startTime.minute}-${currentSlot!.endTime.hour}:${currentSlot!.endTime.minute}]';
      } else if (targetOffice != null) {
        attendanceInfo = 'You cannot mark the attendance now.';
      } else {
        attendanceInfo =
            'You can only mark attendance from a CRIS Office.\n[All CRIS offices are shown with markers on the Google Map.]';
      }
      print('still running');
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  Future<OfficeGeofence?> getTargetOffice(List<OfficeGeofence> offices) async {
    List<OfficeGeofence> insideOffices = [];
    for (var office in offices) {
      OfficeGeofence returnedOffice = await Geofence.getGeofenceStatus(
          officeGeofence: office, position: widget.currentPosition);
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

  AttendanceSlot? getCurrentSlot(List<AttendanceSlot> slots) {
    DateTime now = DateTime.now();
    AttendanceSlot? currentSlot;
    slots.forEach((element) {
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

  // startTimeStream() {
  //   Duration dur = Duration(seconds: 1);
  //   Stream<void> stream = Stream<String>.periodic(dur, callback);
  // }

  // String callback(value) {
  //   DateTime _now = DateTime.now();
  //   return 'Current timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}';
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    _markers = getMarkers();
    _circles = getCircles();
    print('Build called');
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : new Scaffold(
            appBar: AppBar(
              title: Text('Mark Attendance'),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Feather.chevron_left,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(gradient: AppColors.bgLinearGradient),
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: height * 0.6,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.currentPosition.latitude,
                          widget.currentPosition.longitude),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    markers: _markers,
                    circles: _circles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CardWidget(
                      children: [Text(attendanceInfo)], width: double.infinity),
                )
              ],
            ),
            floatingActionButton: Visibility(
              visible: _isVisible,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CameraScreen()));
                },
                label: Text('Mark Attendance'),
                icon: Icon(Feather.user_check),
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.textColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  // Future<void> _goToMyLocation() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       bearing: 192.8334901395799,
  //       target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
  //       tilt: 59.440717697143555,
  //       zoom: 19.151926040649414)));
  // }

  Set<Marker> getMarkers() {
    int i;
    for (i = 0; i < _offices.length; i++) {
      _markers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(
              double.parse(_offices[i].lat), double.parse(_offices[i].lng)),
          infoWindow: InfoWindow(title: _offices[i].officeName),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure)));
    }

    return _markers;
  }

  Set<Circle> getCircles() {
    int i;
    for (i = 0; i < _offices.length; i++) {
      _circles.add(Circle(
        fillColor: AppColors.green.withOpacity(0.4),
        strokeColor: AppColors.green,
        strokeWidth: 1,
        circleId: CircleId('$i'),
        center: LatLng(
            double.parse(_offices[i].lat), double.parse(_offices[i].lng)),
        radius: double.parse(_offices[i].radInMtrs),
      ));
    }
    return _circles;
  }
}
