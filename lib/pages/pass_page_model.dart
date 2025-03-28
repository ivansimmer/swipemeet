import 'pass_page.dart' show PassWidget;
import 'package:flutter/material.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

class PassModel extends FlutterFlowModel<PassWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
