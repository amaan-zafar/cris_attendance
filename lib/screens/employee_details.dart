import 'package:cris_attendance/models/attendance_slots.dart';
import 'package:cris_attendance/screens/map_screen.dart';
import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/widgets/background.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({Key? key}) : super(key: key);

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.bgLinearGradient),
        ),
      ),
      body: BackgroundWidget(
        child: Column(
          children: [
            CardWidget(
              children: [
                SizedBox(height: 24),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1529421308418-eab98863cee4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1055&q=80'),
                  radius: 84,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Amaan Zafar',
                    style: _textTheme.headline6,
                  ),
                ),
                Text(
                  '2019B3PS0463P',
                  style: _textTheme.subtitle1,
                ),
                SizedBox(height: 16),
              ],
              width: double.infinity,
            ),
            SizedBox(height: height * 0.04),
            CardWidget(children: [
              SizedBox(height: 12),
              Text(
                'Last attendance marked',
                style:
                    _textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'On 22-06-2021 at 09:17:36',
                style: _textTheme.subtitle2,
              ),
              SizedBox(height: 12),
            ], width: double.infinity)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position? position = await _getCurrentLocation();
          position != null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MapScreen(
                            currentPosition: position,
                          )))
              : print('Null current positon');
        },
        label: Text('Mark Attendance'),
        icon: Icon(MaterialCommunityIcons.page_next),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.textColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<Position?> _getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10));
      print('Current position is $position');
      return position;
    } catch (e) {
      print('Error in getting current position : ${e.toString()}');
    }
    return null;
  }
}
