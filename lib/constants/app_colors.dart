import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF3A86FF);
  static const Color secondaryColor = Color(0xFFE91E63);

  static const Color boxColor1=Color(0xff9DCEFF);
  static const Color boxColor2=Color(0xffEEA4CE);


  static const Color maleBackground = Color.fromARGB(255, 211, 218, 254);
  static const Color femaleBackground = Color.fromARGB(255, 253, 228, 253);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color shadowColor = Color(0x1A000000);
  static const Color textJourney = Color(0xFF212529);

  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, secondaryColor],
  );
}
