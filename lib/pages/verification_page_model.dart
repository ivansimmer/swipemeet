import 'verification_page.dart' show VerificationPageWidget;
import 'package:flutter/material.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

class VerificationPageModel extends FlutterFlowModel<VerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
