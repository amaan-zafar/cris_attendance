import 'package:cris_attendance/constants/colors.dart';
import 'package:cris_attendance/widgets/background.dart';
import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        centerTitle: true,
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
                SizedBox(height: 24),
                Text(
                  'Amaan Zafar',
                  style: TextStyle(
                      fontSize: 22,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  '2019B3PS0463P',
                  style: TextStyle(fontSize: 16, color: AppColors.textColor),
                ),
                SizedBox(height: 16),
              ],
              width: double.infinity,
            ),
            SizedBox(height: 28),
            CardWidget(children: [
              SizedBox(height: 12),
              Text(
                'Last attendance marked',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'On 22-06-2021 at 09:17:36',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 12),
            ], width: double.infinity)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) => AttendanceInfoScreen()));
        },
        label: Text('Mark Attendance'),
        // icon: Icon(FeatherIcons.userCheck),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.textColor,
      ),
    );
  }
}
