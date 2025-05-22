import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/pages/home_page.dart';
import '/pages/start_page.dart';

class AuthCheckWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return const HomePageWidget(); // Si el usuario está logueado, va a Home
        } else {
          return const StartPageWidget(); // Si no hay usuario, va a la pantalla de inicio
        }
      },
    );
  }
}
