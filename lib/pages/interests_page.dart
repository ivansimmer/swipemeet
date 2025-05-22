import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class InterestsPageWidget extends StatefulWidget {
  const InterestsPageWidget({super.key});

  static String routeName = 'InterestsPage';
  static String routePath = '/interestsPage/';

  @override
  State<InterestsPageWidget> createState() => _InterestsPageWidgetState();
}

class _InterestsPageWidgetState extends State<InterestsPageWidget> {
  late TextEditingController _interestsController;
  List<String> _intereses = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _interestsController = TextEditingController();
    _loadUserInterests(); // cargar intereses al iniciar
  }

  @override
  void dispose() {
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInterests() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null && data['intereses'] != null) {
      setState(() {
        _intereses = List<String>.from(data['intereses']);
      });
    }
  }

  Future<void> _saveInterests() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'intereses': _intereses,
    });
  }

  void _addInteres(String interes) {
    if (interes.isEmpty || _intereses.contains(interes)) return;
    setState(() {
      _intereses.add(interes);
      _interestsController.clear();
    });
    _saveInterests();
  }

  void _removeInteres(String interes) {
    setState(() {
      _intereses.remove(interes);
    });
    _saveInterests();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Row(children: [
                FlutterFlowIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.goNamed('ProfilePage'),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                    child: Text(
                      'Completa tus intereses',
                      style: FlutterFlowTheme.tituloPages,
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                  child: Text(
                    'Introduce tus intereses:',
                    style: FlutterFlowTheme.labelMedium,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: _interestsController,
                    decoration: InputDecoration(
                      hintText: 'Tu interes aquí',
                      hintStyle: FlutterFlowTheme.introHints,
                      filled: true,
                      fillColor: FlutterFlowTheme.secondaryBackground,
                      suffixIcon: InkWell(
                        onTap: () {},
                        child: Icon(Icons.interests_outlined),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: FlutterFlowButton(
                  onPressed: () {
                    final interes = _interestsController.text.trim();
                    _addInteres(interes);
                  },
                  text: 'GUARDAR',
                  color: Color(0xFFAB82FF),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
                child: Text(
                  'Algunos de los intereses que añadas aquí se mostrarán en tu perfil.',
                  style: FlutterFlowTheme.labelMedium.copyWith(fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  itemCount: _intereses.length,
                  itemBuilder: (context, index) {
                    final interes = _intereses[index];
                    return Container(
                      width:  MediaQuery.of(context).size.width * 0.7,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 215, 180, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(interes, style: FlutterFlowTheme.labelMedium),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeInteres(interes),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
