import 'package:go_router/go_router.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'completing_profile2_model.dart';
export 'completing_profile2_model.dart';

class CompletingProfile2Widget extends StatefulWidget {
  final String name; // Variable para el nombre

  const CompletingProfile2Widget({
    super.key,
    required this.name,
  });

  static String routeName = 'CompletingProfile2';
  static String routePath = '/completingProfile2';

  @override
  State<CompletingProfile2Widget> createState() =>
      _CompletingProfile2WidgetState();
}

class _CompletingProfile2WidgetState extends State<CompletingProfile2Widget> {
  late CompletingProfile2Model _model;
  String _borndate = "";  // Variable para la fecha de nacimiento

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model =
        FlutterFlowModel.createModel(context, () => CompletingProfile2Model());
    _model.textController ??= TextEditingController();
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
              LinearPercentIndicator( // Barra de progreso header
                percent: 0.5,
                width: 400,
                lineHeight: 12,
                animation: true,
                animateFromLastPercent: true,
                progressColor: Color(0xFFAB82FF),
                backgroundColor: FlutterFlowTheme.alternate,
                center: Text(
                  '\n',
                  style: FlutterFlowTheme.headlineSmall.copyWith(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
                ),
                padding: EdgeInsets.zero,
              ),

              // Texto fecha nacimiento
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Your born date is:',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Campo para introducir el nombre
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      onChanged: (valueDate) {
                        setState(() {
                          _borndate = valueDate; // Guardamos el valor ingresado
                        });
                      },
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                        hintText: 'DD / MM / YYYY',
                        hintStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.alternate,
                          fontSize: 18,
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
                      textAlign: TextAlign.center,
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your born date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              // Texto info
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(45, 10, 0, 0),
                  child: Text(
                    'Your age will be public',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),

              // Boton continuar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () async {
                    if (_borndate.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your born date')),
                      );
                      return;
                    }

                    // Paso a la siguiente pagina con GoRoute pasando como parametros el nombre y fecha de nacimiento
                    context.go('/completingProfile3Page/${Uri.encodeComponent(widget.name)}/${Uri.encodeComponent(_borndate)}');
                  },
                  text: 'CONTINUE',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
