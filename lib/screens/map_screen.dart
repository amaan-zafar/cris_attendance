import 'dart:async';

import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
                height: height * 0.4,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
