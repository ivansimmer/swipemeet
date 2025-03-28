import 'completing_profile2.dart' show CompletingProfile2Widget;
import 'package:flutter/material.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';

class CompletingProfile2Model
    extends FlutterFlowModel<CompletingProfile2Widget> {
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
