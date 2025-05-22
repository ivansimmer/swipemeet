import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscoverCommunitiesWidget extends StatefulWidget {
  const DiscoverCommunitiesWidget({Key? key}) : super(key: key);

  @override
  State<DiscoverCommunitiesWidget> createState() =>
      _DiscoverCommunitiesWidgetState();
}

class _DiscoverCommunitiesWidgetState extends State<DiscoverCommunitiesWidget> {
  String? currentUid;

  final String azureBaseUrl =
      'https://tindermonlau.blob.core.windows.net/logos';

  final List<String> logoFilenames = [
    'UAB.png',
    'UPC.png',
    'UB.jpg',
    'UPF.png',
    'ESADE.jpg',
    'LA%20SALLE.png',
    'MONLAU.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => currentUid = user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descubrir comunidades"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: currentUid == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allCommunities = snapshot.data!.docs;

                if (allCommunities.isEmpty) {
                  return const Center(
                      child: Text('No hay comunidades disponibles.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: allCommunities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
  final community = allCommunities[index];
  final data = community.data() as Map<String, dynamic>;

  try {
    final name = data['name'] ?? 'Comunidad';
final type = data['type'] ?? 'otro';

String lastMessage;
final raw = data['lastMessage'];

if (raw is String) {
  lastMessage = raw;
} else if (raw is Map) {
  final sender = raw['senderName'] ?? 'Alguien';
  final text = raw['text'] ?? '';
  lastMessage = '$sender: $text';
} else {
  lastMessage = 'Sin mensajes aún';
}


    final List<String> users = [];
    if (data['users'] is List) {
      for (final item in data['users']) {
        if (item is String) {
          users.add(item);
        } else if (item is Map && item['uid'] is String) {
          users.add(item['uid']);
        } else {
          debugPrint('❗ users contiene tipo inesperado: $item');
        }
      }
    } else {
      debugPrint('❗ users NO es lista en ${community.id}');
    }

    final isJoined = users.contains(currentUid);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    final logoFile = logoFilenames.firstWhere(
      (f) => f.toLowerCase().startsWith(name.toLowerCase()),
      orElse: () => '',
    );

    Widget avatar;
    if (type == 'escuela' && logoFile.isNotEmpty) {
      avatar = CircleAvatar(
        backgroundImage: NetworkImage('$azureBaseUrl/$logoFile'),
        radius: 28,
        backgroundColor: Colors.transparent,
      );
    } else if (type == 'estudios') {
      final nameLower = name.toLowerCase();
      IconData icono = Icons.school;
      Color iconColor = Colors.blueGrey;

      if (nameLower.contains('informatica')) {
        icono = Icons.computer;
        iconColor = isDark ? Colors.purpleAccent : Colors.deepPurple;
      } else if (nameLower.contains('ingenieria')) {
        icono = Icons.engineering;
        iconColor = isDark ? Colors.cyanAccent : Colors.teal;
      } else if (nameLower.contains('ciencias de la salud')) {
        icono = Icons.health_and_safety;
        iconColor = isDark ? Colors.redAccent.shade100 : Colors.redAccent;
      } else if (nameLower.contains('economia')) {
        icono = Icons.business_sharp;
        iconColor = isDark ? Colors.lightGreenAccent : Colors.green;
      } else if (nameLower.contains('artes')) {
        icono = Icons.palette;
        iconColor = isDark ? Colors.pink.shade100 : Colors.pinkAccent;
      } else if (nameLower.contains('matematicas')) {
        icono = Icons.calculate;
        iconColor = isDark ? Colors.indigo.shade100 : Colors.indigo;
      } else if (nameLower.contains('humanidades')) {
        icono = Icons.menu_book;
        iconColor = isDark ? Colors.brown.shade300 : Colors.brown;
      } else if (nameLower.contains('ciencias sociales')) {
        icono = Icons.people;
        iconColor = isDark ? Colors.orange.shade200 : Colors.orange;
      }

      avatar = CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.15),
        radius: 28,
        child: Icon(icono, color: iconColor),
      );
    } else {
      avatar = const CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.groups, color: Colors.white),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    )),
                const SizedBox(height: 6),
                Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: subtitleColor),
                ),
                if (isJoined)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text("Ya te has unido",
                            style: TextStyle(fontSize: 13, color: Colors.green)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          isJoined
              ? ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Salir de $name'),
                        content: const Text(
                            '¿Estás seguro de que quieres salir de esta comunidad?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Salir')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('communities')
                          .doc(community.id)
                          .update({
                        'users': FieldValue.arrayRemove([currentUid]),
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Salir", style: TextStyle(color: Colors.white)),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('communities')
                        .doc(community.id)
                        .update({
                      'users': FieldValue.arrayUnion([currentUid]),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB82FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group_add, color: Colors.white),
                      SizedBox(width: 5),
                      Text("Unirse", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
        ],
      ),
    );
  } catch (e, stack) {
    debugPrint('🔥 ERROR procesando comunidad ${community.id}: $e');
    debugPrint(stack.toString());
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.red.shade100,
      child: Text('Error en comunidad ${community.id}: $e'),
    );
  }
}

                );
              },
            ),
    );
  }
}
