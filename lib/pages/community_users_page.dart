import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityUsersPage extends StatefulWidget {
  final String communityId;

  const CommunityUsersPage({Key? key, required this.communityId}) : super(key: key);

  @override
  State<CommunityUsersPage> createState() => _CommunityUsersPageState();
}

class _CommunityUsersPageState extends State<CommunityUsersPage> {
  List<String> userIds = [];
  bool isLoading = true;
  final String defaultPfp =
      'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';

  @override
  void initState() {
    super.initState();
    _loadUserIds();
  }

  Future<void> _loadUserIds() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final users = List<String>.from(data?['users'] ?? []);
        setState(() {
          userIds = users;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading community users: $e');
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Miembros de la comunidad'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userIds.length,
              itemBuilder: (context, index) {
                final uid = userIds[index];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserData(uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final user = snapshot.data!;
                    final name = user['name'] ?? 'Usuario';
                    final image = user['picture'] ?? defaultPfp;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 24,
                      ),
                      title: Text(name),
                      onTap: () {
                        if (uid != currentUid) {
                          // Reemplaza con tu propia navegación al perfil
                          Navigator.pushNamed(
                            context,
                            '/profilePage',
                            arguments: {'uid': uid},
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
