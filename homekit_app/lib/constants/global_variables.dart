import 'package:flutter/material.dart';

String uri = 'http://10.0.2.2:5000';

class GlobalVariables {
  static const secondaryColor = Colors.amberAccent;
  static const buttonDeleteColor = Colors.red;
  static const buttonBackgroundColor = Colors.deepOrange;
  static const primaryColor = Colors.green;
  static const fieldBackgroundColor = Color(0xFFFFFFFF);
  static const fieldColor = Color(0xEFEFEFEF);
  static const backgroundColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 200, 255, 255),
      Color.fromARGB(255, 210, 255, 255),
      Color.fromARGB(255, 255, 255, 255),
    ],
    stops: [0.2, 0.3, 0.5],
  );
  static const weatherBox = LinearGradient(
    colors: [
      Color.fromARGB(255, 227, 242, 247), // Very Light Sky Blue
      Color.fromARGB(255, 156, 211, 225), // Sky Blue
    ],
    stops: [0.5, 1.0],
  );
  static const deviceWidgetBackgroundColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 255,253,253),
    ],
    stops: [0.5, 1.0],
  );
}
