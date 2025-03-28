import 'package:flutter/material.dart';

class FlutterFlowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry iconPadding;
  final double elevation;
  final BorderRadiusGeometry borderRadius;

  const FlutterFlowButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // Default color
    this.width = double.infinity, // Default width
    this.height = 40.0, // Default height
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Default padding
    this.iconPadding = EdgeInsets.zero, // Default icon padding
    this.elevation = 2.0, // Default elevation
    this.borderRadius = const BorderRadius.all(Radius.circular(12)), // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          elevation: elevation,
        ),
      ),
    );
  }
}
