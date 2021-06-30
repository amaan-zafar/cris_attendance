import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMsg;
  const CustomErrorWidget({Key? key, required this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/images/no-data-error.png'),
          fit: BoxFit.cover,
        ),
        Text(errorMsg)
      ],
    );
  }
}
