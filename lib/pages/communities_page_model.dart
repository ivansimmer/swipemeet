import 'package:flutter/material.dart';
import 'package:swipemeet/flutter_flow/tracking_wrapper.dart';

class CommunitiesPageWidget extends StatelessWidget {
  final String screenName;
  final Widget child;

  const CommunitiesPageWidget({
    Key? key,
    required this.screenName,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTrackingWrapper(
      screenName: screenName,
      child: child,
    );
  }
}
