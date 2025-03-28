// /lib/flutter_flow/form_field_controller.dart

import 'package:flutter/material.dart';

class FormFieldController<T> {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  FormFieldController({
    required this.textEditingController,
    required this.focusNode,
  });

  // Validación simple de texto (puedes agregar más lógica aquí)
  String? validateField(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
  }
}
