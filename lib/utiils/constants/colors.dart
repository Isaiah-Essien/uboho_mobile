// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class UColors {
  static const Color primaryColor = Color(0xFF672BB5);
  static const Color onboardingDotColor = Color(0xFFBD95F0);
  static const Color Lavender = Color(0xffE6E5F3);
  static const Color boxHighlightColor = Color(0xFF1E1E1E);
  static const Color backgroundColor = Color(0xFF111111);
  static const Color inputInactiveColor = Color(0xFF393939);
  static const Color dividerColor = Color(0xFF7A7A7A);
  static const Color footerWithTextDividerColor = Color(0xFF393939);


  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(color.value, shades);
  }
}