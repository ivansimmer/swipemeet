import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/custom_navbar.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget>
    with SingleTickerProviderStateMixin {
  String name = "",
      picture = "",
      photo1 = "",
      photo2 = "",
      photo3 = "",
      photo4 = "";
  String university = "",
      studies = "",
      location = "",
      age = "",
      description = "";
  List<String> interests = [], activities = [];
  bool isLoading = true;
  int _selectedIndex = 2;

  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showImageDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Stack(
        children: [
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.6))),
          Center(
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            name = doc['name'] ?? '';
            picture = doc['picture'] ?? '';
            photo1 = doc['photo1'] ?? '';
            photo2 = doc['photo2'] ?? '';
            photo3 = doc['photo3'] ?? '';
            photo4 = doc['photo4'] ?? '';
            university = doc['university'] ?? '';
            studies = doc['studies'] ?? '';
            location = doc['ubicacion'] ?? '';
            description = doc['description'] ?? '';
            final born = doc['born_date'] ?? '';
            age = _calculateAge(born);
            interests = List<String>.from(doc['academic_interests'] ?? []);
            activities = List<String>.from(doc['favorite_activities'] ?? []);
          });
        }
      } catch (e) {
        print("❌ Error: $e");
      }
    }

    setState(() => isLoading = false);
  }

  String _calculateAge(String bornDate) {
    try {
      final parts = bornDate.split('/');
      if (parts.length == 3) {
        final birth = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        final now = DateTime.now();
        int age = now.year - birth.year;
        if (now.month < birth.month ||
            (now.month == birth.month && now.day < birth.day)) {
          age--;
        }
        return age.toString();
      }
    } catch (_) {}
    return "";
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
        context.goNamed('ProfilePage');
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
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: 190,
                                  height: 190,
                                  child: picture.isNotEmpty
                                      ? Image.network(picture,
                                          fit: BoxFit.cover)
                                      : Image.asset(
                                          'assets/default_profile.png'),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Tooltip(
                                  message: 'Editar perfil',
                                  child: GestureDetector(
                                    onTapDown: (_) => _controller.reverse(),
                                    onTapUp: (_) async {
                                      await _controller.forward();
                                      await Future.delayed(
                                          const Duration(milliseconds: 300));
                                      if (mounted) context.goNamed('EditPage');
                                    },
                                    onTapCancel: () => _controller.forward(),
                                    child: ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFAB82FF),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          boxShadow: _isPressed
                                              ? [
                                                  BoxShadow(
                                                      color: Colors.pink
                                                          .withOpacity(0.4),
                                                      blurRadius: 12,
                                                      offset:
                                                          const Offset(0, 6))
                                                ]
                                              : [],
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.edit,
                                            size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                if (age.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    age,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (university.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(university,
                                      style: const TextStyle(fontSize: 16)),
                                ],
                                if (studies.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(studies,
                                      style: const TextStyle(fontSize: 16)),
                                ],
                                if (location.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(location,
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text("Bio",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                          description.isNotEmpty
                              ? description
                              : "Este usuario aún no ha añadido una biografía.",
                          style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 24),
                      const Text("Intereses académicos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      interests.isNotEmpty
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: interests.map((interest) {
                                final isDarkMode =
                                    Theme.of(context).brightness ==
                                        Brightness.dark;
                                final backgroundColor = isDarkMode
                                    ? Colors.grey
                                        .shade700 // Gris más fuerte en modo oscuro
                                    : Colors.grey.shade200;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    interest,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Text("El usuario no tiene intereses.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                      const SizedBox(height: 24),
                      const Text("Actividades favoritas",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      activities.isNotEmpty
                          ? Column(
                              children: [
                                for (int i = 0; i < activities.length; i += 2)
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildActivityIcon(
                                              activities[i])),
                                      if (i + 1 < activities.length)
                                        Expanded(
                                            child: _buildActivityIcon(
                                                activities[i + 1])),
                                    ],
                                  ),
                              ],
                            )
                          : const Text(
                              "El usuario no tiene actividades favoritas.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                      const SizedBox(height: 24),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final photos = [photo1, photo2, photo3, photo4]
                              .where((p) => p.isNotEmpty)
                              .toList();

                          if (photos.isEmpty) {
                            return const Center(
                                child: Text(
                                    "Este usuario no ha añadido fotos adicionales.",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey)));
                          }

                          if (photos.length == 3) {
                            final double totalSpacing = 16 * 2 + 40;
                            final double imageSize =
                                (MediaQuery.of(context).size.width -
                                        totalSpacing) /
                                    3;

                            return Center(
                              child: Row(
                                children: List.generate(3, (index) {
                                  final url = photos[index];
                                  return Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: Duration(
                                            milliseconds: 500 + index * 100),
                                        builder: (context, value, child) =>
                                            Opacity(
                                                opacity: value, child: child),
                                        child: GestureDetector(
                                          onLongPress: () =>
                                              _showImageDialog(context, url),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: CachedNetworkImage(
                                                imageUrl: url,
                                                fit: BoxFit.cover,
                                                placeholder: (context, _) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, _, __) =>
                                                    const Icon(Icons.error,
                                                        color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          } else {
                            return Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 16,
                                runSpacing: 16,
                                children: List.generate(photos.length, (index) {
                                  final url = photos[index];
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: Duration(
                                        milliseconds: 500 + index * 100),
                                    builder: (context, value, child) {
                                      return Opacity(
                                          opacity: value, child: child);
                                    },
                                    child: GestureDetector(
                                      onLongPress: () =>
                                          _showImageDialog(context, url),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: 140,
                                          height: 140,
                                          child: CachedNetworkImage(
                                            imageUrl: url,
                                            fit: BoxFit.cover,
                                            placeholder: (context, _) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget: (context, _, __) =>
                                                const Icon(Icons.error,
                                                    color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Cerrar sesión",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("¿Cerrar sesión?"),
                                content: const Text(
                                    "¿Estás seguro de que deseas cerrar sesión?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancelar"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text("Cerrar sesión",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                context.goNamed('LogInPage');
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildActivityIcon(String label) {
    final icons = {
      "Senderismo": Icons.terrain,
      "Cine": Icons.local_movies,
      "Tocar guitarra": Icons.music_note,
      "Leer": Icons.menu_book,
      "Viajar": Icons.flight,
      "Deportes": Icons.sports_soccer,
      "Cocinar": Icons.restaurant,
      "Pintar": Icons.brush,
      "Fotografía": Icons.camera_alt,
      "Bailar": Icons.music_video,
      "Videojuegos": Icons.videogame_asset,
      "Yoga": Icons.self_improvement,
      "Nadar": Icons.pool,
      "Correr": Icons.directions_run,
      "Escribir": Icons.edit,
      "Escalada": Icons.fitness_center,
      "Café con amigos": Icons.coffee,
      "Patinar": Icons.ice_skating,
      "Ver series": Icons.tv,
      "Jardinería": Icons.local_florist,
      "Meditación": Icons.spa,
      "Voluntariado": Icons.volunteer_activism,
      "Ir al teatro": Icons.theater_comedy,
      "Juegos de mesa": Icons.casino,
      "Estudiar en grupo": Icons.group,
      "Cantar": Icons.mic,
      "Tocar piano": Icons.piano,
      "Fotomontajes": Icons.image,
      "Astronomía": Icons.nights_stay,
      "Ir a conciertos": Icons.audiotrack,
      "Senderismo nocturno": Icons.dark_mode,
      "Esquí": Icons.downhill_skiing,
      "Snowboard": Icons.ac_unit,
      "Tomar bubble tea": Icons.emoji_food_beverage,
      "Pasear al perro": Icons.pets,
      "Aprender idiomas": Icons.language,
      "Lectura de poesía": Icons.book,
      "Ver documentales": Icons.movie_filter,
      "Ciclismo": Icons.directions_bike,
      "Caligrafía": Icons.create,
      "Cerámica": Icons.account_balance,
      "Manualidades": Icons.handyman,
      "Karaoke": Icons.surround_sound,
      "Crossfit": Icons.fitness_center,
      "Zumba": Icons.directions_walk,
      "Maquillaje artístico": Icons.palette,
      "Modelismo": Icons.toys,
      "Tatuajes": Icons.format_paint,
      "Graffiti": Icons.format_color_fill,
      "Parkour": Icons.directions_run,
      "Escalada indoor": Icons.sports_handball,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icons[label] ?? Icons.star_border,
            color: Color(0xFFAB82FF), // Rosa del botón de editar perfil
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
