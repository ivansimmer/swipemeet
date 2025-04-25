import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/models/flutter_flow_model.dart';
import 'completing_profile1_model.dart';

class CompletingProfile1Widget extends StatefulWidget {

  const CompletingProfile1Widget({super.key});

  static String routeName = 'CompletingProfile1';
  static String routePath = '/completingProfile1';

  @override
  State<CompletingProfile1Widget> createState() =>
      _CompletingProfile1WidgetState();
}

class _CompletingProfile1WidgetState extends State<CompletingProfile1Widget> {
  late CompletingProfile1Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = ""; // Variable para recoger el nombre
  final _formKey = GlobalKey<FormState>(); // Usamos un GlobalKey para el formulario

  @override
  void initState() {
    super.initState();
    _model =
        FlutterFlowModel.createModel(context, () => CompletingProfile1Model());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
              // Progress Indicator
              LinearPercentIndicator(
                // Barra de progreso superior
                percent: 0.25,
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

              // Texto introducir nombre
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 50, 0, 0),
                  child: Text(
                    'Tu nombre es:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Campo de introducir el nombre
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // width of the button
                  child: Form(  // Usamos un Form para validar
                    key: _formKey,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      onChanged: (value) {
                        setState(() {
                          _name = value; // Guardamos el valor ingresado en la variable
                        });
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0.0,
                        ),
                        hintText: 'Introduce tu nombre aqui...',
                        hintStyle: FlutterFlowTheme.labelMedium.copyWith(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.error,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.error,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.secondaryBackground,
                      ),
                      style: FlutterFlowTheme.labelMedium.copyWith(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        letterSpacing: 0.0,
                      ),
                      cursorColor: FlutterFlowTheme.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce tu nombre';
                        }
                        RegExp regExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
                        if (!regExp.hasMatch(value)) {
                          return 'Por favor ingresa solo letras';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              // Texto info
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                  child: Text(
                    'Así es como aparecerás en Swipemeet, y no podrás cambiarlo más tarde',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),

              // Botón continuar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                child: FlutterFlowButton(
                  color: Color(0xFFAB82FF),
                  borderRadius: BorderRadius.circular(25),
                  width: MediaQuery.of(context).size.width * 0.75, // width of the button
                  height: MediaQuery.of(context).size.height * 0.07, // width of the button
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si la validación pasa, navega a la siguiente página
                      context.go('/completingProfile2Page/$_name');
                    } else {
                      // Si la validación falla, muestra un mensaje de error
                      _showErrorDialog('Por favor ingresa un nombre válido');
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
