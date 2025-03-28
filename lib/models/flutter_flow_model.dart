import 'package:flutter/material.dart';

// Esta clase base te permitirá manejar la lógica de las páginas de manera consistente
abstract class FlutterFlowModel<T extends StatefulWidget> {
  // Método de inicialización
  void initState(BuildContext context) {}

  // Método de disposición
  void dispose() {}

  // Si es necesario, puedes agregar otros métodos comunes para la gestión de datos o lógica.

  /// Crea un modelo de página para cualquier widget, que maneja la inicialización y limpieza del estado.
  static T createModel<T>(BuildContext context, T Function() create) {
    final model = create();
    if (model is StatefulWidget) {
      // Aquí puedes hacer algo con el estado de la página si es necesario.
    }
    return model;
  }
}
