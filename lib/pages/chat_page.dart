import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/custom_navbar.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'chat_page_model.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  static String routeName = 'ChatPage';
  static String routePath = '/chatPage';

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

// Clase para como se ve el contenedor de cada sala en la pagina
class ChatPreview {
  final types.User user;
  final String lastMessage;
  final DateTime updatedAt;
  final String roomId;
  final bool hasUnread;

  ChatPreview({
    required this.user,
    required this.lastMessage,
    required this.updatedAt,
    required this.roomId,
    required this.hasUnread,
  });
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

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.goNamed('HomePage');
        break;
      case 1:
        context.goNamed('ChatPage');
        break;
      case 2:
        context.goNamed('CommunitiesPage');
        break;
      case 3:
      context.goNamed(
        'MarketplacePage',
        extra: {
          'profileImageUrl': picture.isNotEmpty
              ? picture
              : 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg',
        },
      );
      break;  
      case 4:
        context.goNamed('ProfilePage');
        break;
    }
  }

  // Uso esta funcion para marcar la sala como leida (en caso de no estarlo)
  Future<void> markRoomAsSeen(String roomId, String currentUserId) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final snapshot = await roomRef.get();
    final data = snapshot.data();

    if (data == null) return;

    final participantIds = List<String>.from(data['participantIds']);
    List<bool> seenBy = List<bool>.from(data['seenBy'] ?? []);

    // Compruebo que el campo seenBy sea del mismo tamaño que los participantes de la sala
    if (seenBy.length != participantIds.length) {
      seenBy = List<bool>.filled(participantIds.length, false);
    }

    final index = participantIds.indexOf(currentUserId);
    if (index == -1) return;

    // Con esto marco la sala como vista
    seenBy[index] = true;

    // Y con esto actualizo la bd con el valor
    await roomRef.update({'seenBy': seenBy});
  }

  // Esta funcion me devuelve si hay algun mensaje sin leer o no
  bool hasUnreadMessage(Map<String, dynamic> roomData, String currentUserId) {
    final participants = List<String>.from(roomData['participantIds']);
    final seenBy = List<bool>.from(roomData['seenBy'] ?? []);

    final index = participants.indexOf(currentUserId);
    if (index == -1 || seenBy.length != participants.length) return false;

    return !seenBy[index];
  }
  Future<void> _confirmDeleteChat(String roomId, String otherUserId) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar chat'),
      content: const Text(
          '¿Estás seguro de que deseas eliminar este chat y la conexión? Esta acción eliminará también todos los mensajes.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    try {
      final firestore = FirebaseFirestore.instance;

      // Eliminar mensajes de la subcolección
      final messagesRef = firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Eliminar la sala
      await firestore.collection('rooms').doc(roomId).delete();

      // Eliminar el match
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final matchId = [currentUserId, otherUserId]..sort();
      final matchDocId = matchId.join('_');

      await firestore.collection('matches').doc(matchDocId).delete();

      // 🟢 Ya no hay SnackBar aquí
    } catch (e) {
      debugPrint('Error eliminando chat y mensajes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el chat.')),
      );
    }
  }
}


  // Uso esta funcion para cargar toda la informacion del usuario como correo, nombre, etc
  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            email = userDoc['email'] ?? '';
            name = userDoc['name'] ?? '';
            picture = userDoc['picture'] ??
                'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
  automaticallyImplyLeading: false,
  toolbarHeight: 50,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  elevation: 0,
  title: Align(
    alignment: Alignment.centerLeft,
    child: Image.network(
      'https://tindermonlau.blob.core.windows.net/imagenes/logo_swipe.png',
      height: 150,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 150,
        height: 150,
        color: Colors.grey,
        child: const Center(child: Text('Logo unavailable')),
      ),
    ),
  ),
),
body: SafeArea(
  child: Column(
    children: [
      Expanded(

              // Con esto cargo todas las salas abiertas
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .where('participantIds',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('updatedAt',
                        descending:
                            true) // Gracias a indexarlo, puedo ordenarlo en tiempo descendiente
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                            'No tienes conexiones aún')); // Si no hay salas muestro que no tiene conexiones
                  }

                  final List<ChatPreview> chats = [];

                  for (final doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final participantIds =
                        List<String>.from(data['participantIds']);
                    final otherUserId = participantIds.firstWhere(
                        (id) => id != FirebaseAuth.instance.currentUser!.uid);

                    final hasUnread = hasUnreadMessage(
                        data, FirebaseAuth.instance.currentUser!.uid);

                    chats.add(ChatPreview(
                      // Añado tantos previews como salas hayan
                      user: types.User(
                        id: otherUserId,
                        firstName: '...', // Cargo el nombre posteriormente
                        imageUrl: '', // Cargo la imagen posteriormente
                      ),
                      lastMessage: data['lastMessage'] ??
                          '', // Cargo el ultimo mensaje que hay en bd, si no hay se mostrara espacio vacio
                      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
                          DateTime
                              .now(), // Cargo la fecha del ultimo mensaje, si no hay mensajes aun, pongo la hora actual
                      roomId: doc.id,
                      hasUnread: hasUnread,
                    ));
                  }

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(chat.user.id)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return const SizedBox();
                          }

                          final userDoc = userSnapshot.data!;
                          final user = types.User(
                            id: chat.user.id,
                            firstName: userDoc['name'] ??
                                'Usuario', // Aqui cargo el nombre
                            imageUrl: userDoc['picture'] ??
                                'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg', // Aqui cargo la imagen, si no hay pongo esa por fefecto
                          );

                          final isUnread = hasUnreadMessage(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>,
                            FirebaseAuth.instance.currentUser!.uid,
                          );

                          return ListTile(
  leading: Stack(
    children: [
      CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl!),
      ),
      if (chat.hasUnread)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
  ),
  title: Text(
    user.firstName ?? 'Usuario',
    style: FlutterFlowTheme.headlineSmall,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  subtitle: Text(
    chat.lastMessage,
    style: TextStyle(
      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  trailing: Text(
    TimeOfDay.fromDateTime(chat.updatedAt).format(context),
    style: const TextStyle(fontSize: 12, color: Colors.grey),
  ),
  onTap: () async {
    await markRoomAsSeen(chat.roomId, FirebaseAuth.instance.currentUser!.uid);
    _openChatWithUser(user);
  },
  onLongPress: () => _confirmDeleteChat(chat.roomId, chat.user.id), // ✅ Aquí sí
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
      bottomNavigationBar: CustomNavBar(
  currentIndex: _selectedIndex,
  onTap: _onNavItemTapped,
  profileImageUrl: picture.isNotEmpty
      ? picture
      : 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg',
),

    );
  }

  // Funcion para abir un chat con el usuario que clico
  Future<void> _openChatWithUser(types.User user) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
      final roomRef = await FirebaseFirestore.instance.collection('rooms').add({
        'name': 'Sala de Chat',
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'participantIds': [currentUserId, user.id],
        'seenBy': [true, false], // 👈 Se inicia con el que crea en true
      });

      roomId = roomRef.id;
    }

    final roomSnapshot =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

    final room = types.Room(
      id: roomId,
      name: roomSnapshot['name'],
      createdAt:
          (roomSnapshot['createdAt'] as Timestamp).millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      metadata: {'lastMessage': roomSnapshot['lastMessage']},
      users: [
        types.User(id: currentUserId),
        types.User(id: user.id),
      ],
      type: types.RoomType.direct,
    );

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
  String otherUserName = 'Cargando...';
  String otherUserImage = '';

  @override
  void initState() {
    super.initState();
    _getOtherUserDetails();
    _markSeen();
  }

  Future<void> _markSeen() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room.id)
        .get()
        .then((doc) async {
      final data = doc.data();
      if (data == null) return;

      final participantIds = List<String>.from(data['participantIds']);
      final seenBy = List<bool>.from(data['seenBy'] ?? []);
      final index = participantIds.indexOf(currentUserId);

      if (index != -1 && index < seenBy.length) {
        seenBy[index] = true;
        await doc.reference.update({'seenBy': seenBy});
      }
    });
  }

  Future<void> _getOtherUserDetails() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final otherUserId =
        widget.room.users.firstWhere((user) => user.id != currentUserId).id;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();

    if (userDoc.exists) {
  setState(() {
    otherUserName = userDoc['name'] ?? 'Usuario desconocido';
    otherUserImage = userDoc['picture'] ??
        'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';
  });
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: true,
  toolbarHeight: 60,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  elevation: 0,
  title: Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(otherUserImage),
      ),
      const SizedBox(width: 12),
      Text(
        otherUserName,
        style: Theme.of(context).textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
),



      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(widget.room),
        builder: (context, snapshot) {
  return Chat(
    messages: snapshot.data ?? [],
    onSendPressed: (types.PartialText message) async {
      await FirebaseFirestore.instance
    .collection('rooms')
    .doc(widget.room.id)
    .collection('messages')
    .add({
  'authorId': FirebaseAuth.instance.currentUser!.uid,
  'createdAt': FieldValue.serverTimestamp(),
  'text': message.text,
  'type': 'text',
});

    },
    user: types.User(id: FirebaseAuth.instance.currentUser!.uid),
    l10n: const ChatL10nEn(inputPlaceholder: 'Envía un mensaje'),
    theme: DefaultChatTheme(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F5F5),
      inputBackgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade200,
      inputBorderRadius: BorderRadius.circular(24),
      inputTextColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      inputTextStyle: const TextStyle(fontSize: 15),
    ),
  );
},

      ),
    );
  }
}
