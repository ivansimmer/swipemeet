// /lib/flutter_flow/flutter_flow_icon_button.dart

import 'package:flutter/material.dart';

class FlutterFlowIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const FlutterFlowIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.black,
    );
  }
}
