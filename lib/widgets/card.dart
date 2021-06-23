import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final List<Widget> children;
  final double width;

  const CardWidget({Key? key, required this.children, required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
