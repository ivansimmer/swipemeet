import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDetailPageWidget extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileDetailPageWidget({super.key, required this.profile});

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

  Icon _getActivityIcon(String label) {
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
    return Icon(icons[label] ?? Icons.star_border, color: Color(0xFFAB82FF));
  }

  @override
  Widget build(BuildContext context) {
    final name = profile['name'] ?? '';
    final picture = profile['picture'] ?? '';
    final university = profile['university'] ?? '';
    final studies = profile['studies'] ?? '';
    final location = profile['ubicacion'] ?? '';
    final description = profile['description'] ?? '';
    final born = profile['born_date'] ?? '';
    final age = _calculateAge(born);
    final interests = List<String>.from(profile['academic_interests'] ?? []);
    final activities = List<String>.from(profile['favorite_activities'] ?? []);
    final favoriteSong = profile['favorite_song'] ?? '';
    final favoriteSongImage = profile['favorite_song_image'] ?? '';
    final photoUrls = [
      profile['photo1'] ?? '',
      profile['photo2'] ?? '',
      profile['photo3'] ?? '',
      profile['photo4'] ?? '',
    ].where((p) => p.isNotEmpty).toList();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ROW SUPERIOR = IMAGEN + DATOS PERSONALES
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 140,
                      height: 150,
                      child: picture.isNotEmpty
                          ? Image.network(picture, fit: BoxFit.cover)
                          : Image.asset('assets/default_profile.png'),
                    ),
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
                                const SizedBox(height: 6,),
                                Row(children: [
                                  Text(
                                    "Edad: ", 
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      shadows: isDarkMode
                                          ? const [
                                              Shadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ]
                                          : null
                                      )
                                  ),
                                  if (age.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    age,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      shadows: isDarkMode
                                          ? const [
                                              Shadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ],
                                ],
                                ),
                                
                                if (university.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(university,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
                                ],
                                if (studies.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(studies,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
                                ],
                                if (location.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(location,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
                                ],
                              ],
                            ),
                          ),
                ],
              ),

              const SizedBox(height: 24),
              const Text("Bio",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(description.isNotEmpty
                  ? description
                  : "Este usuario aún no ha añadido una biografía."),
              const SizedBox(height: 24),
              const Text("Intereses académicos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              interests.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interests.map((interest) {
                        final backgroundColor = isDarkMode
                            ? Colors.grey.shade700
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
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 24),
              const Text("Actividades favoritas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              activities.isNotEmpty
                  ? Column(
                      children: [
                        for (int i = 0; i < activities.length; i += 2)
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    _getActivityIcon(activities[i]),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(activities[i])),
                                  ],
                                ),
                              ),
                              if (i + 1 < activities.length)
                                Expanded(
                                  child: Row(
                                    children: [
                                      _getActivityIcon(activities[i + 1]),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(activities[i + 1])),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                      ],
                    )
                  : const Text("El usuario no tiene actividades favoritas.",
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 24),
              if (favoriteSong.isNotEmpty) ...[
                const Text("Canción favorita",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      if (favoriteSongImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            favoriteSongImage,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Icon(Icons.music_note,
                            size: 48, color: Color(0xFFAB82FF)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          favoriteSong,
                          style: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (photoUrls.isNotEmpty)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: photoUrls.map((url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (context, _) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, _, __) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}