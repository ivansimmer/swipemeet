import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_theme_provider.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import 'profile_page_model.dart';

export 'profile_page_model.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;
  String email = "";
  String name = "";
  String picture = "";
  late bool isLoading;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Índice para la página de perfil en la navbar

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => ProfilePageModel());
    _loadUserData();
  }

  // Función para cargar el correo electrónico del usuario desde Firestore
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true; // Comienza la carga
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            email = userDoc['email'] ?? '';
            name = userDoc['name'] ?? '';
            picture = userDoc['picture'] ?? '';
            isLoading = false; // Finaliza la carga
          });
        } else {
          setState(() {
            email = 'No se ha encontrado ningun email';
            name = 'No se ha encontrado ningun nombre';
            picture = 'No se ha encontrado ningun imagen';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          email = 'Error cargando email';
          name = 'Error cargando name';
          name = 'Error cargando picture';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        email = 'Usuario no autenticado';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void setDarkModeSetting(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.goNamed('HomePage'); // Navegar al home
        break;
      case 1:
        context.goNamed('ChatPage'); // Navegar al chat
        break;
      case 2:
        context.goNamed('ProfilePage'); // Navegar al perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // MaterialApp aquí envuelve toda la estructura para cambiar el tema globalmente
    return MaterialApp(
      theme: themeProvider.themeData, // Aplicar el tema según la preferencia
      home: Scaffold(
        key: scaffoldKey,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding( // Titulo header
              padding: const EdgeInsets.only(top: 70, bottom: 30),
              child: Text(
                'SWIPEMEET',
                style: FlutterFlowTheme.swipeHeader,
              ),
            ),
            // Contenido del perfil
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        color: themeProvider.isDarkMode
                          ? Color.fromRGBO(19, 18, 18, 1)
                          : Colors.white,
                        offset: Offset(0.0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          // Imagen del perfil
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(picture,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.isEmpty ? 'Cargando...' : name,
                                style: FlutterFlowTheme.headlineSmall.copyWith(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: Text(
                                  email.isEmpty ? 'Cargando...' : email,
                                  style:
                                      FlutterFlowTheme.headlineSmall.copyWith(
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Botón para cambiar el tema
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (themeProvider.isDarkMode)
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        setDarkModeSetting(context);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cambiar a Modo Claro',
                                  style: FlutterFlowTheme.optionsProfile),
                              Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.primaryBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 0),
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(-0.9, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 2, 0, 0),
                                        child: Icon(
                                          Icons.wb_sunny_rounded,
                                          color: FlutterFlowTheme.secondaryText,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.9, 0),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x430B0D0F),
                                              offset: Offset(
                                                0.0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!themeProvider.isDarkMode)
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        setDarkModeSetting(context);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cambiar a Modo Oscuro',
                                  style: FlutterFlowTheme.optionsProfile),
                              Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 0),
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.95, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                        child: Icon(
                                          Icons.nights_stay,
                                          color: FlutterFlowTheme.secondaryText,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(-0.85, 0),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x430B0D0F),
                                              offset: Offset(
                                                0.0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Otras configuraciones de la cuenta
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 12, 0, 12),
                      child: Text('Ajustes de la cuenta',
                          style: FlutterFlowTheme.optionsProfile),
                    ),
                  ],
                ),
              ],
            ),

            // Opciones de configuración
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x3416202A),
                          offset: Offset(0.0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                            child: Text(
                              'Editar Perfil',
                              style: FlutterFlowTheme.optionsProfile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Cambiar intereses
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: InkWell(
                    onTap: () {
                      // Navegar hacia la página ChangePassPage
                      //context.goNamed(
                          //'PassPage'); // Asegúrate de registrar esta ruta en tu enrutador
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0x3416202A),
                            offset: Offset(0.0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.interests_outlined,
                              size: 20,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                              child: Text(
                                'Cambiar Intereses',
                                style: FlutterFlowTheme.optionsProfile,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Botón "Log Out"
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                  child: FlutterFlowButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      context.goNamed('StartPage');
                    },
                    text: 'Cerrar Sesion',
                    height: 50,
                    color: Color(0xFFAB82FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
