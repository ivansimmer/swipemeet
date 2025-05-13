import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ScreenTrackingWrapper extends StatefulWidget {
  final String screenName;
  final Widget child;

  const ScreenTrackingWrapper({
    super.key,
    required this.screenName,
    required this.child,
  });

  @override
  State<ScreenTrackingWrapper> createState() => _ScreenTrackingWrapperState();
}

class _ScreenTrackingWrapperState extends State<ScreenTrackingWrapper> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    FirebaseAnalytics.instance.logScreenView(screenName: widget.screenName);
  }

  @override
  void dispose() {
    final timeSpent = DateTime.now().difference(_startTime).inSeconds;
    debugPrint('Tiempo en ${widget.screenName}: $timeSpent segundos');
    FirebaseAnalytics.instance.logEvent(
      name: 'time_on_screen',
      parameters: {
        'screen_name': widget.screenName,
        'duration_seconds': timeSpent,
      },
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}