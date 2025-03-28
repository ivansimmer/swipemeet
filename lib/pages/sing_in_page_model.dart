import 'package:swipemeet/models/flutter_flow_model.dart';

import 'sign_in_page.dart' show SignInPageWidget;
import 'package:flutter/material.dart';

class SignInPageModel extends FlutterFlowModel<SignInPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  // State field(s) for TextFieldPassword widget.
  FocusNode? textFieldPasswordFocusNode;
  TextEditingController? textFieldPasswordTextController;
  bool textFieldPasswordVisibility = false;
  String? Function(BuildContext, String?)?
      textFieldPasswordTextControllerValidator;
  // State field(s) for TextFieldConfirm widget.
  FocusNode? textFieldConfirmFocusNode;
  TextEditingController? textFieldConfirmTextController;
  bool textFieldConfirmVisibility = false;
  String? Function(BuildContext, String?)?
      textFieldConfirmTextControllerValidator;

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibility = false;
    textFieldConfirmVisibility = false;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();

    textFieldConfirmFocusNode?.dispose();
    textFieldConfirmTextController?.dispose();
  }
}
