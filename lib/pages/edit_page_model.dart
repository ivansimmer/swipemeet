import 'edit_page.dart' show EditWidget;
import 'package:swipemeet/models/flutter_flow_model.dart';

class EditModel extends FlutterFlowModel<EditWidget> {
  String name = "Usuario Ejemplo";
  String email = "usuario@example.com";

  void updateProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
  }
}
