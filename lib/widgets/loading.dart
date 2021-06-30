import 'package:cris_attendance/widgets/card.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: CardWidget(
        width: width * 0.6,
        height: width * 0.6,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text(text)
        ],
      ),
    );
  }
}
