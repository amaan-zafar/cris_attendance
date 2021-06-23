import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height / 4,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  // gradient: Styles.bgLinearGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16))),
            ),
            // Container(
            //   width: double.infinity,
            //   height: topPadding + 74,
            //   decoration: BoxDecoration(

            //       // gradient: Styles.bgLinearGradient,
            //       ),
            // ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 48, 16, 0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
