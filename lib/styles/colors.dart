import 'package:flutter/material.dart';

class AppColors {
  static const Color green = Color(0xFF1DDFB0);
  static const Color textColor = Color(0xFF3F2E5C);
  static const Color bgColorBeginGradient = Color(0xFF4e54c8);
  static const Color bgColorEndGradient = Color(0xFF8f94fb);

  static const Color white = Color(0xFFE6E6FA);
  static const Color grey1 = Color(0xFFC4C4C4);
  static const Color grey2 = Color(0xFF65656B);
  static const Color black1 = Color(0xFF222232);
  static const Color black2 = Color(0xFF181829);
  static const Color blue = Color(0xFF246BFD);
  static const Color darkBlue = Color(0xFF14274D);
  static const Color brown1 = Color(0xFF441818);

  static LinearGradient bgLinearGradient = LinearGradient(
    colors: [bgColorBeginGradient, bgColorEndGradient],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
