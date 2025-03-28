// /lib/auth/firebase_auth/auth_util.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para registrar un nuevo usuario con correo y contraseña
  static Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error durante la registración: $e");
      return null;
    }
  }

  // Función para iniciar sesión con correo y contraseña
  static Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error durante el inicio de sesión: $e");
      return null;
    }
  }

  // Función para cerrar sesión
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
