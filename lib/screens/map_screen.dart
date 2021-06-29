import 'dart:async';

import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/models/employee.dart';
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

  late List<OfficeGeofence> _offices;

  late List<AttendanceSlot> slots;

  late Position _currentPosition;

  List<Map<String, dynamic>> _insideGeofencesData = [];

  OfficeGeofence? selectedOffice;

  Set<Marker> _markers = {};

  Set<Circle> _circles = {};

  bool _isTimeSlot = false;

  @override
  void initState() {
    _offices = [
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
          lat: "25.587476691908993",
          lng: "85.09496933762402",
          radInMtrs: "100"),
    ];
    slots = [
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
    _currentPosition = widget.currentPosition;
    getInsideOffices();
    super.initState();
  }

  getInsideOffices() {
    Map<String, dynamic> geofenceData;
    _offices.forEach((element) async {
      geofenceData = await Geofence.getGeofenceStatus(
          pointedLatitude: element.lat,
          pointedLongitude: element.lng,
          radiusMeter: element.radInMtrs,
          position: widget.currentPosition);
      if (geofenceData['event'] == GeofenceEvent.inside) {
        _insideGeofencesData.add(geofenceData);
      }
    });
  }

  startTimeStream() {
    Duration dur = Duration(seconds: 1);
    Stream<void> stream = Stream<String>.periodic(dur, callback);
  }

  String callback(value) {
    DateTime _now = DateTime.now();
    return 'Current timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}';
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    _markers = getMarkers();
    _circles = getCircles();
    return new Scaffold(
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
          OfficeInfoWidget()
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isTimeSlot,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CameraScreen()));
          },
          label: Text('Mark Attendance'),
          icon: Icon(Feather.user_check),
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.textColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

class OfficeInfoWidget extends StatelessWidget {
  final String? officeName;
  const OfficeInfoWidget({Key? key, this.officeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(children: [
      Text(officeName != null
          ? 'Mark your attendance at $officeName'
          : 'You can only mark attendance from a CRIS Office.\n[All CRIS offices are shown with markers on the Google Map.]')
    ], width: double.infinity);
  }
}
