import 'interests_page.dart' show InterestsPageWidget;
import 'package:flutter/material.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

class InterestsPageModel extends FlutterFlowModel<InterestsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();
  }
}
