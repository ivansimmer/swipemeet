import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import 'package:swipemeet/pages/sing_in_page_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

export 'sign_in_page.dart';

class SignInPageWidget extends StatefulWidget {
  const SignInPageWidget({super.key});

  static String routeName = 'SignInPage';
  static String routePath = '/signInPage';

  @override
  State<SignInPageWidget> createState() => _SignInPageWidgetState();
}

class _SignInPageWidgetState extends State<SignInPageWidget> {
  late SignInPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => SignInPageModel());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();

    _model.textFieldConfirmTextController ??= TextEditingController();
    _model.textFieldConfirmFocusNode ??= FocusNode();
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
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'Sign - in',
                    style: FlutterFlowTheme.headlineSmall.copyWith(
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'Enter your email:',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: _model.textFieldEmailTextController,
                      focusNode: _model.textFieldEmailFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                        alignLabelWithHint: false,
                        hintText: 'exampleemail@gmail.com',
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
                      style: FlutterFlowTheme.bodyMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Enter your password:',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: 300,
                  child: TextFormField(
                    controller: _model.textFieldPasswordTextController,
                    focusNode: _model.textFieldPasswordFocusNode,
                    autofocus: false,
                    obscureText: !_model.textFieldPasswordVisibility,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      hintText: 'password',
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
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _model.textFieldPasswordVisibility =
                              !_model.textFieldPasswordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.textFieldPasswordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 22,
                        ),
                      ),
                    ),
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    cursorColor: FlutterFlowTheme.primaryText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Confirm your password:',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: 300,
                  child: TextFormField(
                    controller: _model.textFieldConfirmTextController,
                    focusNode: _model.textFieldConfirmFocusNode,
                    autofocus: false,
                    obscureText: !_model.textFieldConfirmVisibility,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      hintText: 'password',
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
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _model.textFieldConfirmVisibility =
                              !_model.textFieldConfirmVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.textFieldConfirmVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 22,
                        ),
                      ),
                    ),
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    cursorColor: FlutterFlowTheme.primaryText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: Text(
                  'We will send a text with a verification code.\nMessage and data rates may apply. Learn what\nhappens when your number changes.',
                  style: FlutterFlowTheme.bodyMedium.copyWith(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: FlutterFlowButton(
                    onPressed: () async {
                      // Check if passwords match
                      if (_model.textFieldPasswordTextController?.text !=
                          _model.textFieldConfirmTextController?.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Passwords don\'t match!'),
                          ),
                        );
                        return;
                      }

                      try {
                        // Firebase Authentication: Create account with email and password
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _model.textFieldEmailTextController!.text,
                          password: _model.textFieldPasswordTextController!.text,
                        );

                        // You can access the user using userCredential.user
                        final user = userCredential.user;

                        if (user != null) {
                          // Account successfully created, navigate to the next page
                          context.goNamed('CompletingProfile1Page');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to create account.')),
                          );
                        }
                      } catch (e) {
                        // Handle any errors from Firebase (e.g. network issues, invalid email format)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error creating account: $e'),
                          ),
                        );
                      }
                    },
                    text: 'CONTINUE',
                    width: 300, // width of the button
                    height: 40, // height of the button
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16, 0, 16, 0), // padding inside the button
                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                        0, 0, 0, 0), // icon padding
                    color: Color(0xFFAB82FF), // background color of the button
                    elevation: 0, // elevation of the button
                    borderRadius: BorderRadius.circular(20), // border radius
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }
}
