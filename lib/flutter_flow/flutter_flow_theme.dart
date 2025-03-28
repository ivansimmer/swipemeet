import 'package:flutter/material.dart';

class FlutterFlowTheme {
  static ThemeMode themeMode = ThemeMode.light; // Valor inicial

  // Colores y estilos según el tema (claro o oscuro)
  static Color get primaryBackground => themeMode == ThemeMode.light
      ? Color(0xFFF7F7F7) // Color de fondo en modo claro
      : Color(0xFF181818); // Color de fondo en modo oscuro
  
  static Color get secondaryBackground => themeMode == ThemeMode.light
      ? Color(0xFFFFFFFF) // Fondo secundario en modo claro
      : Color(0xFF2C2C2C); // Fondo secundario en modo oscuro
  
  static Color get primary => themeMode == ThemeMode.light
      ? Color(0xFF181818)// Color primario en modo claro
      : Color(0xFFF7F7F7); // Color primario en modo oscuro

  static Color get secondaryText => themeMode == ThemeMode.light
      ? Colors.black // Texto secundario en modo claro
      : Colors.white; // Texto secundario en modo oscuro

  static TextStyle get headlineSmall => TextStyle(
        fontSize: 18,
        color: FlutterFlowTheme.primary
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 16,
        color: themeMode == ThemeMode.light ? Colors.black : Colors.white,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 14,
        color: themeMode == ThemeMode.light ? Colors.grey : Colors.white60,
      );

  static Color get primaryText => const Color.fromARGB(255, 0, 0, 0);

  static TextStyle get labelMedium => TextStyle(
    fontSize: 14.0, 
    color: Colors.grey[600]!
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 12.0, 
    color: const Color.fromARGB(255, 0, 0, 0)
  );

  static TextStyle get headlineBig => TextStyle(
    fontSize: 30.0, 
    fontWeight: FontWeight.bold, 
    color: Colors.black
  );

  static Color get error => Colors.red;
  static Color get alternate => Colors.blueGrey;
  static Color get borderButton => const Color.fromARGB(255, 255, 255, 255);
  static TextStyle get buttonText => TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle get titleText => TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white);
}
