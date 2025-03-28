// /lib/flutter_flow/flutter_flow_util.dart

import 'package:flutter/material.dart';

class FlutterFlowUtil {
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  static bool responsiveVisibility({
    required BuildContext context,
    bool phone = true,
    bool tablet = true,
    bool desktop = true,
  }) {
    final width = MediaQuery.of(context).size.width;

    // You can adjust these breakpoints as needed
    if (width <= 600) {
      return phone; // Show on phone
    } else if (width <= 1200) {
      return tablet; // Show on tablet
    } else {
      return desktop; // Show on desktop
    }
  }
}
