import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'chat_page_model.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  static String routeName = 'ChatPage';
  static String routePath = '/chatPage';

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  late ChatPageModel _model;
  int _selectedIndex = 1;
  String email = "";
  String name = "";
  String picture = "";
  bool isLoading = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = ChatPageModel();
    _loadUserData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            email = userDoc['email'] ?? '';
            name = userDoc['name'] ?? '';
            picture = userDoc['picture'] ?? 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';
          });
        } else {
          setState(() {
            email = 'No se ha encontrado ningun email';
            name = 'No se ha encontrado ningun nombre';
          });
        }
      } catch (e) {
        setState(() {
          email = 'Error cargando email';
          name = 'Error cargando nombre';
        });
      }
    } else {
      setState(() => email = 'Usuario no autenticado');
    }
    setState(() => isLoading = false);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.goNamed('HomePage');
        break;
      case 1:
        context.goNamed('ChatPage');
        break;
      case 2:
        context.goNamed('ProfilePage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('SWIPEMEET', style: FlutterFlowTheme.swipeHeader),
            ),
            Expanded(
              child: StreamBuilder<List<types.User>>(
                stream: FirebaseChatCore.instance.users(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id) // Obtener datos del usuario con el id correspondiente
                            .get(),
                        builder: (context, userDocSnapshot) {
                          if (userDocSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (userDocSnapshot.hasData && userDocSnapshot.data != null) {
                            final otherUser = userDocSnapshot.data!;
                            final otherUserName = otherUser['name'] ?? 'Usuario desconocido';
                            final otherUserPicture = otherUser['picture'] ??
                                'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(otherUserPicture),
                              ),
                              title: Text(otherUserName, style: FlutterFlowTheme.headlineSmall),
                              onTap: () => _openChatWithUser(user),
                            );
                          }

                          return const ListTile(
                            title: Text('Usuario no encontrado'),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFAB82FF),
        onTap: _onItemTapped,
      ),
    );
  }

  // 🔥 Función para abrir o crear un chat con otro usuario
  Future<void> _openChatWithUser(types.User user) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Buscar si ya existe un chat entre estos dos usuarios
    final query = await FirebaseFirestore.instance
        .collection('rooms')
        .where('participantIds', arrayContains: currentUserId)
        .get();

    String roomId = '';

    for (var doc in query.docs) {
      List<dynamic> participantIds = doc['participantIds'];
      if (participantIds.contains(user.id)) {
        roomId = doc.id;
        break;
      }
    }

    if (roomId.isEmpty) {
      // Crear una nueva sala de chat si no existe
      final roomRef = await FirebaseFirestore.instance.collection('rooms').add({
        'name': 'Sala de Chat',
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'participantIds': [currentUserId, user.id],
      });

      roomId = roomRef.id;
    }

    // Obtener los datos de la sala
    final roomSnapshot =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

    final room = types.Room(
      id: roomId,
      name: roomSnapshot['name'],
      createdAt: (roomSnapshot['createdAt'] as Timestamp).millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      metadata: {'lastMessage': roomSnapshot['lastMessage']},
      users: [
        types.User(id: currentUserId),
        types.User(id: user.id),
      ],
      type: types.RoomType.direct,
    );

    // Navegar a la pantalla del chat con la sala correcta
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(room: room)),
    );
  }
}

class ChatPage extends StatefulWidget {
  final types.Room room;

  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String otherUserName = 'Cargando...';  // Default placeholder text


  @override
  void initState() {
    super.initState();
    _getOtherUserDetails();
  }

  // Obtener detalles del otro usuario (nombre y foto de perfil)
  Future<void> _getOtherUserDetails() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Obtener los ids de los participantes, excluyendo al usuario actual
    final otherUserId = widget.room.users
        .firstWhere((user) => user.id != currentUserId)
        .id;

    // Obtener los datos del otro usuario desde Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();

    if (userDoc.exists) {
      setState(() {
        otherUserName = userDoc['name'] ?? 'Usuario desconocido';
      });
    } else {
      setState(() {
        otherUserName = 'Usuario desconocido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName.isEmpty ? 'Cargando...' : otherUserName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Navega hacia atrás
          },
        ),
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(widget.room),
        builder: (context, snapshot) {
          return Chat(
            messages: snapshot.data ?? [],
            onSendPressed: (types.PartialText message) {
              FirebaseChatCore.instance.sendMessage(message, widget.room.id);
            },
            user: types.User(id: FirebaseAuth.instance.currentUser!.uid),
          );
        },
      ),
    );
  }
}
