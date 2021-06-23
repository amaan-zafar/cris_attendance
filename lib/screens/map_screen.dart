import 'dart:async';

import 'package:cris_attendance/models/attendance.dart';
import 'package:cris_attendance/models/employee.dart';
import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  late List<OfficeGeofence> _offices;

  late List<AttendanceSlot> slots;

  late Position _currentPosition;

  Set<Marker> markers = {};

  @override
  void initState() {
    _getCurrentLocation();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return new Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        leading: Icon(
          FeatherIcons.chevronLeft,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.bgLinearGradient),
        ),
      ),
      body: Column(
        children: [
          CardWidget(
            width: double.infinity,
            children: [
              Container(
                height: height * 0.6,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(25.585381090862434, 85.09535758698132),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ],
          ),
          Text('Mark my attendance')
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMyLocation,
      //   label: Text('Go to my location'),
      //   icon: Icon(FeatherIcons.navigation),
      // ),
    );
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10));
    print('Current position is $_currentPosition');
  }

  getMarkers() async {
    int i;
    for (i = 0; i < _offices.length; i++) {
      markers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(
              double.parse(_offices[i].lat), double.parse(_offices[i].lng)),
          infoWindow: InfoWindow(title: _offices[i].officeName),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure)));
    }
    markers.add(Marker(
        markerId: MarkerId('$i'),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        infoWindow: InfoWindow(title: _offices[i].officeName),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
    return markers;
  }
}
