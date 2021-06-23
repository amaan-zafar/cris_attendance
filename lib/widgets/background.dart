import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: height / 4,
            decoration: BoxDecoration(
                color: Colors.blue,
                // gradient: Styles.bgLinearGradient,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16))),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 48, 16, 0),
            child: child,
          ),
        ],
      ),
    );
  }
}
