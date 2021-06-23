import 'package:cris_attendance/styles/colors.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: height / 4,
            decoration: BoxDecoration(
                // color: Colors.blue,
                gradient: AppColors.bgLinearGradient,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16))),
          ),
          Container(
            margin:
                EdgeInsets.fromLTRB(width * 0.05, height / 16, width * 0.05, 0),
            child: child,
          ),
        ],
      ),
    );
  }
}
