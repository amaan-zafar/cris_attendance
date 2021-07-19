import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:cris_attendance/widgets/error.dart';
import 'package:cris_attendance/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';

class CameraScreen extends StatefulWidget {
  final int empId;
  final Position currentPosition;
  const CameraScreen(
      {required this.currentPosition, required this.empId, Key? key})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  Map<String, Object>? metadata;

  final ImagePicker _picker = ImagePicker();

  void _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      if (pickedFile != null) {
        Exif exif = await Exif.fromPath(pickedFile.path);
        await exif.writeAttributes({
          'GPSLongitude': '${widget.currentPosition.longitude}',
          'GPSLatitude': '${widget.currentPosition.latitude}'
        });
        metadata = await exif.getAttributes();
      }
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print('Error on picking is ${e.toString()}');
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void _completeAttendance() async {
    if (_imageFile != null) {
      List<int> imgBytes = await _imageFile!.readAsBytes();
      String base64Img = base64Encode(imgBytes);
      print('base64 is $base64Img');

      // final path = await getApplicationDocumentsDirectory();
      // Uint8List bytes = base64Decode(base64Img);
      // var file = File('$path/counter.jpg');
      // file.writeAsBytes(bytes);
      // Exif exif = await Exif.fromPath(_imageFile!.path);
      // print('exiffinal is ${await exif.getAttributes()}');
    }
  }

  Widget _previewImage() {
    final _textTheme = Theme.of(context).textTheme;

    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.4,
              child: Semantics(
                  child: Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                  ),
                  label: 'image_picker_picked_image'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
              child: CardWidget(children: [
                Text(
                  'Geotagged Data',
                  style: _textTheme.bodyText1!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(metadata.toString())
              ], width: double.infinity),
            )
          ],
        ),
      );
    } else if (_pickImageError != null) {
      return CustomErrorWidget(
          errorMsg: 'Error in picking image : $_pickImageError');
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image(
              image: AssetImage('assets/images/selfie.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 18,
          ),
          const Text(
            'Click your image to complete the attendance process.',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Feather.chevron_left),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.bgLinearGradient),
        ),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return LoadingWidget(text: 'Loading');
                    case ConnectionState.done:
                      return _previewImage();
                    default:
                      if (snapshot.hasError) {
                        return CustomErrorWidget(
                            errorMsg:
                                'Error in picking image : ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/selfie.png'),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            const Text(
                              'You have not yet clicked an image.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                  }
                },
              )
            : _previewImage(),
      ),
      floatingActionButton: _imageFile == null
          ? FloatingActionButton.extended(
              label: Text('Click Selfie'),
              onPressed: () {
                _getImage(ImageSource.camera);
              },
              tooltip: 'Take a Photo',
              icon: const Icon(Icons.camera_alt),
              backgroundColor: AppColors.bgColorBeginGradient,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                _completeAttendance();
              },
              label: Text('Complete Attendance'),
              icon: Icon(Feather.user_check),
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.textColor,
            ),
      floatingActionButtonLocation: _imageFile != null
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
