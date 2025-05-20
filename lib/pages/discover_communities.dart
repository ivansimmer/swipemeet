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
                final List<QueryDocumentSnapshot> discoverable = allCommunities
                    .where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final users = List<String>.from(data['users'] ?? []);
                      final type = data['type'] ?? '';
                      return !users.contains(currentUid) &&
                          type != 'escuela' &&
                          type != 'estudios';
                    })
                    .toList();

                if (discoverable.isEmpty) {
                  return const Center(
                      child: Text('Ya perteneces a todas las comunidades.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: discoverable.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final community = discoverable[index];
                    final data = community.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Comunidad';
                    final lastMessage =
                        data['lastMessage'] ?? 'Sin mensajes aún';

                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    final cardColor =
                        isDark ? const Color(0xFF2C2C2C) : Colors.white;
                    final titleColor = isDark ? Colors.white : Colors.black;
                    final subtitleColor =
                        isDark ? Colors.white70 : Colors.black54;

                    final logoFile = logoFilenames.firstWhere(
                      (f) => f.toLowerCase().startsWith(name.toLowerCase()),
                      orElse: () => '',
                    );

                    Widget avatar;
                    if (logoFile.isNotEmpty) {
                      avatar = CircleAvatar(
                        backgroundImage:
                            NetworkImage('$azureBaseUrl/$logoFile'),
                        radius: 28,
                        backgroundColor: Colors.transparent,
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
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('communities')
                                  .doc(community.id)
                                  .update({
                                'users': FieldValue.arrayUnion([currentUid]),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Te has unido a $name exitosamente'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB82FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("Unirse"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
