import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_icon_button.dart';
import 'package:swipemeet/pages/home_page.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class LogInPageWidget extends StatefulWidget {
  const LogInPageWidget({super.key});

  static String routeName = 'LogInPage';
  static String routePath = '/logInPage/:ubicacion';

  @override
  State<LogInPageWidget> createState() => _LogInPageWidgetState();
}

class _LogInPageWidgetState extends State<LogInPageWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisibility = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Metodo de Firebase para iniciar sesion con correo y contraseña
  Future<User?> _signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        // Uso el email y la contraseña que el usuario introduce en los campos
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  // Titulo de la pagina
                  alignment: AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                    child: Text(
                      'Iniciar sesion',
                      style: FlutterFlowTheme.tituloPages,
                    ),
                  ),
                ),
              ]),
              Align(
                // Texto para el email
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Introduce tu correo:',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Align(
                // Input del email
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // width of the button
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'emailejemplo@gmail.com',
                        hintStyle: FlutterFlowTheme.introHints,
                        filled: true,
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                // Texto para la contraseña
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Introduce tu contraseña:',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                // Input de la contraseña
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // width of the button
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisibility,
                    decoration: InputDecoration(
                      hintText: 'contraseña',
                      filled: true,
                      hintStyle: FlutterFlowTheme.introHints,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _passwordVisibility = !_passwordVisibility;
                          });
                        },
                        child: Icon(
                          _passwordVisibility
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Cambiar contraseña
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                child: InkWell(
                  onTap: () {
                    // Navegar hacia la página ChangePassPage
                    context.goNamed(
                        'PassPage'); // Asegúrate de registrar esta ruta en tu enrutador
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // width of the button
                    height: MediaQuery.of(context).size.height *
                        0.06, // width of the button
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 204, 204, 204),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.key_outlined,
                            color: FlutterFlowTheme.secondaryText,
                            size: 20,
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                            child: Text(
                              'Cambiar Contraseña',
                              style: FlutterFlowTheme.labelMedium.copyWith(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                // Texto de informacion
                padding: EdgeInsetsDirectional.fromSTEB(50, 70, 50, 0),
                child: Text(
                  'Clicando el siguiente boton seras redirigido a la pagina inicial de Swipemeet.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                // Boton para continuar
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () async {
                    // Recojo lo que se ha escrito en los campos
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    // Realizo el inicio de sesion con firebase
                    User? user =
                        await _signInWithEmailPassword(email, password);

                    if (user != null) {
                      // Si el inicio de sesion ha sido exitoso voy a la pagina home
                      context.pushNamed(
                        HomePageWidget.routeName,
                        // Transicion efecto degradade
                        extra: <String, dynamic>{
                          'transition': CustomTransitionPage(
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: HomePageWidget(),
                          ),
                        },
                      );
                    } else {
                      // Muestro error si el login no es exitoso
                      if (email.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'El campo email no puede estar vacio. Introduce tu correo.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else if (password.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'El campo contraseña no puede estar vacio. Introduce tu contraseña.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Inicio de sesion fallido. Prueba otra vez.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  text: 'CONTINUAR',
                  color: Color(0xFFAB82FF), // Color del boton
                  width: MediaQuery.of(context).size.width *
                      0.7, // width of the button
                  height: MediaQuery.of(context).size.height *
                      0.07, // width of the button
                  padding: EdgeInsetsDirectional.fromSTEB(
                      16, 0, 16, 0), // Margen interior
                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0, 0, 0, 0), // Margen del icono
                  elevation: 0, // Elevacion del boton
                  borderRadius:
                      BorderRadius.circular(25), // Esquinas redondeadas
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
