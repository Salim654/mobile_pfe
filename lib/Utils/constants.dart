import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Constants {
  static const String baseUrl = 'http://192.168.1.16:8000/api';
  static void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 3000),
      width: kIsWeb ? 500 : 350,
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static const Color color1 = Color(0xff04bbff);
  static const Color color2 = Color(0xff0594d0);
  static const Color color3 = Color(0xff007198);
  static const Color color4 = Color(0xff003c57);
  static const Color color5 = Color(0xff051c24);
}
