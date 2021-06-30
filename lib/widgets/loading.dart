import 'package:cris_attendance/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitThreeBounce(
            color: AppColors.bgColorEndGradient,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    );
  }
}
