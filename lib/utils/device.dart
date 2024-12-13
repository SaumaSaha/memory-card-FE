import 'package:flutter/material.dart';

class Device {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }
}