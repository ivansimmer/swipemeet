import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/pages/user_profile.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'completing_profile3_model.dart';
export 'completing_profile3_model.dart';

class CompletingProfile3Widget extends StatefulWidget {
  final String name;
  final String borndate;
  const CompletingProfile3Widget(
      {super.key,
      required this.name,
      required this.borndate});

  static String routeName = 'CompletingProfile3';
  static String routePath = '/completingProfile3';

  @override
  State<CompletingProfile3Widget> createState() =>
      _CompletingProfile3WidgetState();
}

class _CompletingProfile3WidgetState extends State<CompletingProfile3Widget> {
  late CompletingProfile3Model _model;

  // Variables para los datos pasados desde las paginas anteriores
  String? _name;
  String? _bornDate;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model =
        FlutterFlowModel.createModel(context, () => CompletingProfile3Model());

    // Inicializa los valores predeterminados para los dropdowns
    _model.dropDownValue1 = 'Monlau Centre d\'Estudis'; // Valor predeterminado
    _model.dropDownValue2 = 'CFGS DAM'; // Valor predeterminado
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _name = widget.name;
    _bornDate = widget.borndate;

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
              LinearPercentIndicator(
                // Barra de progreso header
                percent: 0.75,
                width: MediaQuery.of(context).size.width *
                    1, // width of the button
                lineHeight: 12,
                animation: true,
                animateFromLastPercent: true,
                progressColor: const Color(0xFFAB82FF),
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
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    // Texto subtitulo
                    'Tu perfil de estudiante:',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    // Texto escuela
                    '¿Donde estudias?',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: FlutterFlowDropDown(
                  // Dropdown escuelas
                  items: const ['Monlau Centre d\'Estudis', 'UOC', 'UB'],
                  selectedItem: _model.dropDownValue1,
                  onChanged: (val) =>
                      setState(() => _model.dropDownValue1 = val),
                  width: MediaQuery.of(context).size.width *
                      0.75, // width of the button
                  height: MediaQuery.of(context).size.height *
                      0.07, // width of the button
                  textStyle: FlutterFlowTheme.labelMedium.copyWith(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                  hintText: 'Select...',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.secondaryBackground,
                  elevation: 2,
                  borderColor: Colors.black,
                  borderWidth: 1,
                  borderRadius: 25,
                  margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  hidesUnderline: true,
                  isOverButton: false,
                  isSearchable: false,
                  isMultiSelect: false,
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 60, 0, 0),
                  child: Text(
                    // Texto estudios
                    '¿Que estas estudiando?',
                    style: FlutterFlowTheme.labelMedium.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: FlutterFlowDropDown(
                  // Dropdown estudios
                  items: const ['CFGS DAM', 'Computer Science', 'CFGS DAW'],
                  selectedItem: _model.dropDownValue2,
                  onChanged: (val) =>
                      setState(() => _model.dropDownValue2 = val),
                  width: MediaQuery.of(context).size.width *
                      0.75, // width of the button
                  height: MediaQuery.of(context).size.height *
                      0.07, // width of the button
                  textStyle: FlutterFlowTheme.labelMedium.copyWith(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                  hintText: 'Select...',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.secondaryBackground,
                  elevation: 2,
                  borderColor: Colors.black,
                  borderWidth: 1,
                  borderRadius: 25,
                  margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  hidesUnderline: true,
                  isOverButton: false,
                  isSearchable: false,
                  isMultiSelect: false,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: FlutterFlowButton(
                  color: const Color(0xFFAB82FF),
                  borderRadius: BorderRadius.circular(25),
                  width: MediaQuery.of(context).size.width *
                      0.75, // width of the button
                  height: MediaQuery.of(context).size.height *
                      0.07, // width of the button
                  onPressed: () async {
                    // Asegurar de que el usuario esta autenticado
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      // Crear el perfil del usuario
                      UserProfile userProfile = UserProfile(
                        email:
                            currentUser.email ?? '', // Cojo el email del signin
                        name: _name ??
                            'Unknown', // Pongo el nombre que paso de las paginas anteriores, si no hay pongo Unknown
                        bornDate: _bornDate ??
                            'Unknown', // Pongo la fecha de nacimiento pasada de la anterior, si no pongo Unknown
                        university: _model.dropDownValue1 ??
                            'Unknown', // Asigno el valor que se escoge en el dropdown de escuelas
                        studies: _model.dropDownValue2 ??
                            'Unknown', // Asigno el valor que se escoge en el dropdown de estudios
                        ubicacion: 'Ubicacion Desconocida',
                        intereses: [],
                        pictureUrl:
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', // Imagen fija por ahora
                      );

                      // Guardar el perfil del usuario en Firestore bajo una coleccion users
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .set(userProfile.toMap());

                      // Navegar a la pagina principal
                      context.goNamed('HomePage');
                    } else {
                      // Mostrar alerta personalizada si no hay usuario autenticado
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error de autenticación'),
                          content: const Text(
                              'No se ha encontrado un usuario autenticado. Por favor, inicia sesión e intenta de nuevo.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
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
