import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/models/flutter_flow_model.dart';
import 'package:flutter/material.dart';

import 'chat_page_model.dart';
export 'chat_page_model.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  static String routeName = 'ChatPage';
  static String routePath = '/chatPage';

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  late ChatPageModel _model;
  int _selectedIndex = 1; // Para la navbar, 1 es el índice del chat

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => ChatPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.goNamed('HomePage'); // Redirijo la pagina a Home con GoRoute
        break;
      case 1:
        context.goNamed('ChatPage'); // Redirijo la pagina a Chat con GoRoute
        break;
      case 2:
        context.goNamed('ProfilePage'); // Redirijo la pagina a Profile con GoRoute
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align( // Header pagina
                alignment: AlignmentDirectional(0, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                  child: Text(
                    'SWIPEMEET',
                    style: FlutterFlowTheme.bodyMedium.copyWith(
                      fontFamily: 'Inter',
                      color: Color(0xFFAB82FF),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container( // Contenedor donde estaran los chats
                width: 330,
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 2),
                ),
                alignment: AlignmentDirectional(-1, -1),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 400, maxHeight: 70),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: AlignmentDirectional(0, -1),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    'https://picsum.photos/seed/772/600',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, -0.15),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(80, 0, 0, 0),
                                child: Text(
                                  'Rachel',
                                  style: FlutterFlowTheme.bodyMedium.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar( // Barra de navegacion
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFFAB82FF),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}