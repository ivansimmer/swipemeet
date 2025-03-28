import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/pages/home_page.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class LogInPageWidget extends StatefulWidget {
  const LogInPageWidget({super.key});

  static String routeName = 'LogInPage';
  static String routePath = '/logInPage';

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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        backgroundColor: FlutterFlowTheme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align( // Titulo de la pagina
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'Log - in',
                    style: FlutterFlowTheme.headlineBig,
                  ),
                ),
              ),
              Align( // Texto para el email
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Enter your email:',
                    style: FlutterFlowTheme.bodyMedium,
                  ),
                ),
              ),
              Align( // Input del email
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'exampleemail@gmail.com',
                        filled: true,
                        fillColor: FlutterFlowTheme.secondaryBackground,
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align( // Texto para la contraseña
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 50, 0, 0),
                  child: Text(
                    'Enter your password:',
                    style: FlutterFlowTheme.bodyMedium,
                  ),
                ),
              ),
              Padding( // Input de la contraseña
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: 300,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisibility,
                    decoration: InputDecoration(
                      hintText: 'password',
                      filled: true,
                      fillColor: FlutterFlowTheme.secondaryBackground,
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
              Padding( // Texto de informacion
                padding: EdgeInsetsDirectional.fromSTEB(50, 100, 50, 0),
                child: Text(
                  'By clicking the following button, you will be redirected to Swipemeet\'s home page.',
                  style: FlutterFlowTheme.bodyMedium.copyWith(fontSize: 12),
                ),
              ),
              Padding( // Boton para continuar
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () async {
                    // Recojo lo que se ha escrito en los campos
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    // Realizo el inicio de sesion con firebase
                    User? user = await _signInWithEmailPassword(email, password); 

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Login failed. Please try again.')),
                      );
                    }
                  },
                  text: 'CONTINUE',
                  color: Color(0xFFAB82FF), // Color del boton
                  width: 300, // Ancho del boton
                  height: 40, // Altura del boton
                  padding: EdgeInsetsDirectional.fromSTEB(
                      16, 0, 16, 0), // Margen interior
                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0, 0, 0, 0), // Margen del icono
                  elevation: 0, // Elevacion del boton
                  borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
