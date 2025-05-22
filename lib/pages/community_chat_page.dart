import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/pages/community_users_page.dart'; // Página a crear para ver miembros

class CommunityChatPage extends StatefulWidget {
  final String communityId;
  final String communityName;

  const CommunityChatPage({
    Key? key,
    required this.communityId,
    required this.communityName,
  }) : super(key: key);

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _messageController = TextEditingController();
  late final types.User chatUser;
  String? logoUrl;
  IconData? fallbackIcon;

  final String azureBaseUrl = 'https://tindermonlau.blob.core.windows.net/logos';

  final Map<String, Color> universityColors = {
    'UAB': Color(0xFF007A33),
    'UPC': Color(0xFF0055A4),
    'UB': Color(0xFF002147),
    'UPF': Color(0xFFBC1E47),
    'ESADE': Color(0xFF003865),
    'LA SALLE': Color(0xFFDAA520),
    'MONLAU': Color(0xFFDD0055),
  };

  @override
  void initState() {
    super.initState();
    chatUser = types.User(
      id: currentUser.uid,
      firstName: currentUser.displayName ?? 'Usuario',
    );
    _loadCommunityLogo();
  }

  void _loadCommunityLogo() async {
    final doc = await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .get();

    final data = doc.data();
    if (data != null) {
      final name = data['name'] ?? '';
      final type = data['type'] ?? '';

      if (type == 'escuela') {
        final filename = [
          'UAB.png',
          'UPC.png',
          'UB.jpg',
          'UPF.png',
          'ESADE.jpg',
          'LA%20SALLE.png',
          'MONLAU.png',
        ].firstWhere(
          (f) => f.toLowerCase().startsWith(name.toLowerCase()),
          orElse: () => '',
        );
        if (filename.isNotEmpty) {
          setState(() {
            logoUrl = '$azureBaseUrl/$filename';
          });
        }
      } else if (type == 'estudios') {
        final nameLower = name.toLowerCase();
        if (nameLower.contains('informatica')) {
          fallbackIcon = Icons.computer;
        } else if (nameLower.contains('ingenieria')) {
          fallbackIcon = Icons.engineering;
        } else if (nameLower.contains('salud')) {
          fallbackIcon = Icons.health_and_safety;
        } else if (nameLower.contains('economia')) {
          fallbackIcon = Icons.business;
        } else if (nameLower.contains('artes')) {
          fallbackIcon = Icons.palette;
        } else if (nameLower.contains('matematicas')) {
          fallbackIcon = Icons.calculate;
        } else if (nameLower.contains('humanidades')) {
          fallbackIcon = Icons.menu_book;
        } else {
          fallbackIcon = Icons.school;
        }
      } else {
        fallbackIcon = Icons.group;
      }
    }
  }

  Stream<List<types.Message>> getMessageStream() {
    return FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return types.TextMessage(
          id: doc.id,
          author: types.User(
            id: data['senderId'] ?? '',
            firstName: data['senderName'] ?? 'Usuario',
          ),
          text: data['text'] ?? '',
          createdAt: (data['timestamp'] as Timestamp?)?.millisecondsSinceEpoch,
        );
      }).toList();
    });
  }

  void _sendMessage(types.PartialText message) async {
    final text = message.text.trim();
    if (text.isEmpty) return;

    final messageData = {
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName ?? 'Anónimo',
    };

    final messagesRef = FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('messages');

    final docRef = messagesRef.doc();

    await docRef.set(messageData);

    await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .update({
      'lastMessage': {
        'text': text,
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? 'Anónimo',
        'timestamp': DateTime.now().toIso8601String(),
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityUsersPage(communityId: widget.communityId),
              ),
            );
          },
          child: Row(
            children: [
              if (logoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(logoUrl!),
                  backgroundColor: Colors.transparent,
                )
              else if (fallbackIcon != null)
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(fallbackIcon, color: Colors.black),
                ),
              const SizedBox(width: 8),
              Text(widget.communityName, style: TextStyle(color: textColor)),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: textColor,
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: getMessageStream(),
        builder: (context, snapshot) {
          return Chat(
            messages: snapshot.data ?? [],
            onSendPressed: _sendMessage,
            user: chatUser,
            showUserAvatars: true,
            showUserNames: true,
            theme: DefaultChatTheme(
              inputBackgroundColor: isDark ? Color(0xFF2C2C2E) : Color(0xFFF0F0F0),
              inputTextColor: isDark ? Colors.white : Colors.black87,
              primaryColor: Color(0xFFAB82FF),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          );
        },
      ),
    );
  }
}