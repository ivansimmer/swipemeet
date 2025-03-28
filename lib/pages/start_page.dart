import 'package:go_router/go_router.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'start_page_model.dart';
export 'start_page_model.dart';

class StartPageWidget extends StatefulWidget {
  const StartPageWidget({super.key});

  static String routeName = 'StartPage';
  static String routePath = '/startPage';

  @override
  State<StartPageWidget> createState() => _StartPageWidgetState();
}

class _StartPageWidgetState extends State<StartPageWidget> {
  late StartPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => StartPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFAB82FF),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 150, 0, 0),
                  child: Text(
                    'SWIPEMEET',
                    style: FlutterFlowTheme.titleText,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 200, 50, 0),
                  child: Text(
                    'By tapping Sign In or Log In, you agree to our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.labelSmall.copyWith(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      context.goNamed('SignInPage');
                    },
                    child: Text(
                      'SIGN IN WITH EMAIL',
                      style: FlutterFlowTheme.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAB82FF), // button color
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(color: FlutterFlowTheme.borderButton, width: 1)
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      context.goNamed('LogInPage');
                    },
                    child: Text(
                      'LOG IN WITH EMAIL',
                      style: FlutterFlowTheme.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAB82FF), // button color
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(color: FlutterFlowTheme.borderButton, width: 1)
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
