import 'dart:async';

import 'package:cris_attendance/models/attendance.dart';
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

  List<OfficeGeofence> _insideOffices = [];

  Set<Marker> _markers = {};

  Set<Circle> _circles = {};

  @override
  void initState() {
    _offices = [
      OfficeGeofence(
          officeName: "School",
          lat: "25.58790",
          lng: "85.09500",
          radInMtrs: "80"),
      OfficeGeofence(
          officeName: "Dominoz",
          lat: "25.585381090862434",
          lng: "85.09535758698132",
          radInMtrs: "100"),
      OfficeGeofence(
          officeName: "Office 3",
          lat: "25.587476691908993",
          lng: "85.09496933762402",
          radInMtrs: "150"),
    ];
    _currentPosition = widget.currentPosition;
    getInsideOffices();
    super.initState();
  }

  getInsideOffices() {
    GeofenceEvent event;
    _offices.forEach((element) async {
      event = await Geofence.getGeofenceStatus(
          pointedLatitude: element.lat,
          pointedLongitude: element.lng,
          radiusMeter: element.radInMtrs,
          position: widget.currentPosition);
      if (event == GeofenceEvent.inside) {
        _insideOffices.add(element);
        print('office is ${element.officeName}');
      }
    });
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
          CardWidget(
              children: [Text('Mark your attendance at Office 1')],
              width: double.infinity)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CameraScreen()));
        },
        label: Text('Mark Attendance'),
        icon: Icon(Feather.user_check),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.textColor,
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
