import 'package:cris_attendance/styles/colors.dart';
import 'package:cris_attendance/styles/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
        // Common Theme
        appBarTheme: AppBarTheme(centerTitle: true),
        fontFamily: 'Source Sans Pro',
        //Specific
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: textTheme.apply(
            bodyColor: AppColors.textColor, displayColor: AppColors.textColor),
        iconTheme: IconThemeData(color: AppColors.grey2)
        // buttonTheme: ButtonThemeData(
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        //   buttonColor: CustomColors.lightPurple,
        // )
        );
  }
}
