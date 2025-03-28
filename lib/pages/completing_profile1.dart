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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Progress Indicator
              LinearPercentIndicator( // Barra de progreso superior
                percent: 0.25,
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

              // Texto introducir nombre
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 50, 0, 0),
                  child: Text(
                    'Your name is:',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
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
                  width: 300,
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
                      hintText: 'Enter your name here...',
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
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      letterSpacing: 0.0,
                    ),
                    cursorColor: FlutterFlowTheme.primaryText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Texto info
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 10, 30, 0),
                  child: Text(
                    'This is how it will appear in Swipemeet and you will not be able to change it',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),

              // Boton continuar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () async {
                    // Uso GoRoute para navegar a la siguiente pagina pasando el nombre como parametro
                    context.go('/completingProfile2Page/$_name');
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
