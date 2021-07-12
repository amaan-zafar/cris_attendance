import 'dart:io';

import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:cris_attendance/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  String metadata = '';
  bool hasGpsData = false;

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
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
              height: MediaQuery.of(context).size.height * 0.6,
              child: Semantics(
                  child: Image.file(File(_imageFile!.path)),
                  label: 'image_picker_picked_image'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CardWidget(children: [
                Text(
                  'Metadata Information',
                  style: _textTheme.bodyText1!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(metadata)
              ], width: double.infinity),
            )
          ],
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
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
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Click Selfie'),
        onPressed: () {
          _onImageButtonPressed(ImageSource.camera, context: context);
        },
        tooltip: 'Take a Photo',
        icon: const Icon(Icons.camera_alt),
        backgroundColor: AppColors.bgColorBeginGradient,
      ),
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

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
