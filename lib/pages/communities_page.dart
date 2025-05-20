import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/custom_navbar.dart';

class CommunitiesWidget extends StatefulWidget {
  const CommunitiesWidget({Key? key}) : super(key: key);

  @override
  State<CommunitiesWidget> createState() => _CommunitiesWidgetState();
}

class _CommunitiesWidgetState extends State<CommunitiesWidget> {
  int _selectedIndex = 2;
  String picture = '';
  String? currentUid;

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

  final List<String> logoFilenames = [
    'UAB.png',
    'UPC.png',
    'UB.jpg',
    'UPF.png',
    'ESADE.jpg',
    'LA%20SALLE.png',
    'MONLAU.png',
  ];

  final Color defaultIconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        setState(() {
          currentUid = currentUser.uid;
          picture = doc['picture'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("❌ Error al cargar foto de perfil: $e");
    }
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
      case 3:
        context.goNamed('ProfilePage');
        break;
      case 2:
        context.goNamed('CommunitiesPage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: currentUid == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .where('users', arrayContains: currentUid) 
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final communities = snapshot.data!.docs;

                // dentro del StreamBuilder...
return Column(
  children: [
    Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: communities.length + 1,
        itemBuilder: (context, index) {
  if (index < communities.length) {
    final community = communities[index];
    final data = community.data() as Map<String, dynamic>;
    final name = data['name'] ?? 'Comunidad';
    final type = data['type'] ?? 'otro';
    final users = List<String>.from(data['users'] ?? []);
    final lastMessage = data['lastMessage'] ?? 'Sin mensajes aún';
    final unreadCount = data['unreadCount'] ?? 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    IconData icono = Icons.group;
    Color iconColor = Colors.grey;
    Widget avatar;

          if (type == 'escuela') {
            final logoFile = logoFilenames.firstWhere(
              (f) => f.toLowerCase().startsWith(name.toLowerCase()),
              orElse: () => '',
            );
            if (logoFile.isNotEmpty) {
              avatar = CircleAvatar(
                backgroundImage: NetworkImage('$azureBaseUrl/$logoFile'),
                radius: 28,
                backgroundColor: Colors.transparent,
              );
            } else {
              iconColor = universityColors[name] ?? Colors.grey;
              avatar = CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                radius: 28,
                child: Icon(Icons.account_balance, color: iconColor),
              );
            }
          } else if (type == 'estudios') {
            final nameLower = name.toLowerCase();
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
                      } else {
                        icono = Icons.school;
                        iconColor = isDark ? Colors.grey.shade400 : Colors.blueGrey;
                      }
            avatar = CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.15),
              radius: 28,
              child: Icon(icono, color: iconColor),
            );
          } else {
            iconColor = Colors.blueGrey;
            icono = Icons.group;
            avatar = CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.15),
              radius: 28,
              child: Icon(icono, color: iconColor),
            );
          }

          return GestureDetector(
      onTap: () => context.push('/community_chat/${community.id}'),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: subtitleColor,
                      )),
                  if (type != 'escuela' && type != 'estudios') ...[
                    const SizedBox(height: 6),
                    Text(
                      'Ya te has unido',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (type != 'escuela' && type != 'estudios')
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.grey),
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
              ),
          ],
        ),
      ),
    );
            } else {
            // 👇 Botón al final
            return Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 32),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/discover_communities'),
                  icon: const Icon(Icons.explore),
                  label: const Text('Descubrir comunidades'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    ),
  ],
);
              },
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
}
