import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: FlutterFlowIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () async {
              context.goNamed('LogInPage');
            },
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                child: Text(
                  'Olvidé mi contraseña',
                  style: FlutterFlowTheme.tituloPages
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32, 20, 32, 10),
                child: Text(
                  'Te enviaremos un correo con un link con el que podras restablecer tu contraseña. Por favor, introduce el correo asociado con tu cuenta.',
                  style: FlutterFlowTheme.labelMedium.copyWith(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32, 12, 32, 0),
                child: Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.emailAddressTextController,
                    focusNode: _model.emailAddressFocusNode,
                    autofillHints: [AutofillHints.email],
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Tu direccion de correo...',
                      labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      hintText: 'Introduce el correo aqui...',
                      hintStyle: FlutterFlowTheme.introHints,
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
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: FlutterFlowTheme.primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce un correo valido';
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
                              'El correo es necesario!',
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
                            content: Text('Link para restablecer la contraseña enviado!'),
                          ),
                        );
                        // Mostrar un AlertDialog o SnackBar, luego redirigir a la página de inicio de sesión.
                        await Future.delayed(Duration(seconds: 2));  // Esperar 2 segundos
                        context.goNamed('LogInPage');  // Redirigir a la página de login
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                          ),
                        );
                      }
                    },
                    text: 'Enviar Link',
                    color: Color(0xFFAB82FF),
                    height: 50,
                    width: 270,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(25),
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
