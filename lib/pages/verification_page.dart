import 'package:swipemeet/models/flutter_flow_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'verification_page_model.dart';
export 'verification_page_model.dart';

class VerificationPageWidget extends StatefulWidget {
  const VerificationPageWidget({super.key});

  static String routeName = 'VerificationPage';
  static String routePath = '/verificationPage';

  @override
  State<VerificationPageWidget> createState() => _VerificationPageWidgetState();
}

class _VerificationPageWidgetState extends State<VerificationPageWidget> {
  late VerificationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model =
        FlutterFlowModel.createModel(context, () => VerificationPageModel());

    _model.textController ??= TextEditingController(text: '000000');
    _model.textFieldFocusNode ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'My code is:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 34,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                        hintText: '\n',
                        hintStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.error,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.error,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.secondaryBackground,
                      ),
                      style: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        color: Color(0xFF7D8183),
                        fontSize: 30,
                        letterSpacing: 0.0,
                      ),
                      textAlign: TextAlign.center,
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the verification code';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 230, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'CONTINUAR',
                  width: 300,
                  height: 40,
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: Color(0xFFAB82FF),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
