import 'dart:async';

import 'package:cris_attendance/blocs/map_screen_bloc/map_screen_bloc.dart';
import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/models/office_geofence.dart';
import 'package:cris_attendance/screens/camera_screen.dart';
import 'package:cris_attendance/services/geofence.dart';
import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:cris_attendance/widgets/empty_state.dart';
import 'package:cris_attendance/widgets/error.dart';
import 'package:cris_attendance/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cris_attendance/globals/globals.dart' as globals;

class MapScreen extends StatefulWidget {
  final Position currentPosition;
  MapScreen({Key? key, required this.currentPosition}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  List<OfficeGeofence> _offices = globals.offices;

  Set<Marker> _markers = {};

  Set<Circle> _circles = {};

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

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MapScreenBloc>(context)
        .add(LoadMapScreen(widget.currentPosition));
    var height = MediaQuery.of(context).size.height;
    final _textTheme = Theme.of(context).textTheme;

    _markers = getMarkers();
    _circles = getCircles();
    return BlocBuilder<MapScreenBloc, MapScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: state is LoadingMapScreen
              ? LoadingWidget(text: state.message)
              : state is MapScreenLoaded
                  ? Column(
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
                          child: CardWidget(children: [
                            Text(
                              'Attendance Information',
                              style: _textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text('Office : ${state.officeInfo}'),
                            Text('Time Slot : ${state.slotInfo}'),
                            state.canMark == false
                                ? Text('You cannot mark the attendance')
                                : EmptyStateWidget()
                          ], width: double.infinity),
                        )
                      ],
                    )
                  : state is MapScreenError
                      ? CustomErrorWidget(
                          errorMsg: state.message,
                          onPressed: () =>
                              BlocProvider.of<MapScreenBloc>(context)
                                  .add(LoadMapScreen(widget.currentPosition)),
                        )
                      : EmptyStateWidget(),
          floatingActionButton: Visibility(
            visible: state is MapScreenLoaded ? state.canMark : false,
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

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
