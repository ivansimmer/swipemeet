import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'pass_page_model.dart';
export 'pass_page_model.dart';

class PassWidget extends StatefulWidget {
  const PassWidget({super.key});

  static String routeName = 'Pass';
  static String routePath = '/pass';

  @override
  State<PassWidget> createState() => _PassWidgetState();
}

class _PassWidgetState extends State<PassWidget> {
  late PassModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => PassModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryBackground,
        automaticallyImplyLeading: false,
        leading: Container(
          width: 60, // Set button size
          height: 60, // Set button size
          decoration: BoxDecoration(
            color: Colors
                .transparent, // Optional: Set background color if you need one
            borderRadius: BorderRadius.circular(30), // Border radius
            border: Border.all(
              color: Colors.transparent, // Set the border color if needed
              width: 1, // Border width
            ),
          ),
          child: FlutterFlowIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
          child: Text(
            'Back',
            style: FlutterFlowTheme.headlineSmall.copyWith(
              fontFamily: 'Inter Tight',
              fontSize: 16,
              letterSpacing: 0.0,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Align(
        alignment: AlignmentDirectional(0, -1),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570,
          ),
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This row exists for when the "app bar" is hidden on desktop, having a way back for the user can work well.
              if (FlutterFlowUtil.responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: FlutterFlowTheme.primaryText,
                            size: 24,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Back',
                            style: FlutterFlowTheme.bodyMedium.copyWith(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  'Forgot Password',
                  style: FlutterFlowTheme.headlineSmall.copyWith(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                child: Text(
                  'We will send you an email with a link to reset your password, please enter the email associated with your account below.',
                  style: FlutterFlowTheme.labelMedium.copyWith(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.emailAddressTextController,
                    focusNode: _model.emailAddressFocusNode,
                    autofillHints: [AutofillHints.email],
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Your email address...',
                      labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      hintText: 'Enter your email...',
                      hintStyle: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.alternate,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.secondaryBackground,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                    ),
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: FlutterFlowTheme.primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FlutterFlowButton(
                    onPressed: () async {
                      if (_model.emailAddressTextController?.text.isEmpty ?? true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email required!',
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _model.emailAddressTextController?.text ?? '',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password reset link sent!'),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                          ),
                        );
                      }
                    },
                    text: 'Send Link',
                    color: FlutterFlowTheme.primary,
                    height: 50,
                    width: 270,
                    elevation: 3,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
