import 'package:cris_attendance/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMsg;
  final void Function()? onPressed;
  const CustomErrorWidget({Key? key, required this.errorMsg, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/no-data-error.png'),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 18),
          Text(
            errorMsg,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          MaterialButton(
            onPressed: onPressed,
            color: AppColors.bgColorEndGradient,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.refresh_sharp,
                  color: Colors.white,
                ),
                Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
