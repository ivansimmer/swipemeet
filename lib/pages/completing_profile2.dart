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
  static String routePath = '/completingProfile2/:name';

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

  bool isValidDateFormat(String input) {
    final RegExp dateRegExp = RegExp(
      r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$'
    );

    if (!dateRegExp.hasMatch(input)) return false;

    try {
      final parts = input.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final DateTime date = DateTime(year, month, day);
      return date.day == day && date.month == month && date.year == year;
    } catch (e) {
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
              LinearPercentIndicator( // Barra de progreso header
                percent: 0.5,
                width: MediaQuery.of(context).size.width * 1, // width of the button
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
                    'Tu fecha de nacimiento es:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Campo para introducir la fecha de nacimiento
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // width of the button
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
                      style: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                      textAlign: TextAlign.center,
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor, introduce tu fecha de nacimiento';
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
                    'Tu edad será calculada a partir de esta fecha, y aparecerá públicamente en Swipemeet.',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),

              // Botón continuar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: FlutterFlowButton(
                  color: Color(0xFFAB82FF),
                  borderRadius: BorderRadius.circular(25),
                  width: MediaQuery.of(context).size.width * 0.75, // width of the button
                  height: MediaQuery.of(context).size.height * 0.07, // width of the button
                  onPressed: () async {
                    if (_borndate.isEmpty) {
                      _showErrorDialog('Por favor, introduce tu fecha de nacimiento');
                    }

                    if (!isValidDateFormat(_borndate)) {
                      _showErrorDialog('Por favor, ingresa una fecha válida en formato DD/MM/YYYY');
                    } else {
                      // Paso a la siguiente página con GoRoute pasando como parámetros el nombre y fecha de nacimiento
                      context.go('/completingProfile3Page/${Uri.encodeComponent(widget.name)}/${Uri.encodeComponent(_borndate)}');
                    }
                  },
                  text: 'CONTINUAR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
