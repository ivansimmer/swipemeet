import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_icon_button.dart';
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
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(children: [
                FlutterFlowIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () async {
                    context.goNamed('StartPage');
                  },
                ),
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                    child: Text('Crea tu cuenta',
                        style: FlutterFlowTheme.tituloPages),
                  ),
                ),
              ]),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'Introduce tu correo:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
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
                    width: MediaQuery.of(context).size.width *
                        0.7, // width of the button
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
                        hintText: 'emailejemplo@gmail.com',
                        hintStyle: FlutterFlowTheme.introHints,
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
                        letterSpacing: 0.0,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce un correo';
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
                    'Introduce tu contraseña:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // width of the button
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
                      hintText: 'contraseña',
                      hintStyle: FlutterFlowTheme.introHints,
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
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    cursorColor: FlutterFlowTheme.primaryText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una contraseña';
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
                    'Confirma tu contraseña:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // width of the button
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
                      hintText: 'contraseña',
                      hintStyle: FlutterFlowTheme.introHints,
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
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    cursorColor: FlutterFlowTheme.primaryText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: FlutterFlowButton(
                    onPressed: () async {
                      final List<String> dominiosPermitidos = [
                        '@campus.monlau.com',
                        '@gmail.com',
                        // Agrega más dominios aquí si quieres
                      ];

                      // Función para obtener un mensaje personalizado del error de Firebase
                      String getFirebaseErrorMessage(String code) {
                        switch (code) {
                          case 'email-already-in-use':
                            return 'Este correo ya está en uso. Intenta con otro.';
                          case 'invalid-email':
                            return 'El correo no es válido.';
                          case 'weak-password':
                            return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
                          case 'operation-not-allowed':
                            return 'Esta operación no está permitida. Contacta al soporte.';
                          default:
                            return 'Rellena todos los campos correctamente.';
                        }
                      }

                      // Validar que las contraseñas coincidan
                      if (_model.textFieldPasswordTextController?.text !=
                          _model.textFieldConfirmTextController?.text) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('¡Las contraseñas no coinciden!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      // Normalizar correo
                      final email = _model.textFieldEmailTextController!.text
                          .trim()
                          .toLowerCase();

                      // Validar dominio permitido
                      bool emailPermitido = dominiosPermitidos.any(
                        (dominio) => email.endsWith(dominio.toLowerCase()),
                      );

                      if (!emailPermitido) {
                        debugPrint(
                            'Correo no permitido, cancelando creación de cuenta');

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Correo no permitido'),
                            content: Text(
                                'Solo se permiten correos con dominios autorizados.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password:
                              _model.textFieldPasswordTextController!.text,
                        );

                        final user = userCredential.user;

                        if (user != null) {
                          context.goNamed('CompletingProfile1Page');
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error al crear cuenta'),
                              content: Text(
                                  'No se pudo crear la cuenta. Intenta nuevamente.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        String errorMsg = 'Ocurrió un error.';
                        if (e is FirebaseAuthException) {
                          errorMsg = getFirebaseErrorMessage(e.code);
                        }

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error al crear cuenta'),
                            content: Text(errorMsg),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    text: 'CONTINUAR',
                    width: MediaQuery.of(context).size.width *
                        0.7, // width of the button
                    height: MediaQuery.of(context).size.height *
                        0.07, // height of the button
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16, 0, 16, 0), // padding inside the button
                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                        0, 0, 0, 0), // icon padding
                    color: Color(0xFFAB82FF), // background color of the button
                    elevation: 0, // elevation of the button
                    borderRadius: BorderRadius.circular(25), // border radius
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
