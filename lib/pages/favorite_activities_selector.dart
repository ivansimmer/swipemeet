import 'dart:ui';
import 'package:flutter/material.dart';

class FavoriteActivitiesSelectorDialog extends StatefulWidget {
  final List<String> selectedActivities;
  final Function(List<String>) onActivitiesSelected;

  const FavoriteActivitiesSelectorDialog({
    super.key,
    required this.selectedActivities,
    required this.onActivitiesSelected,
  });

  @override
  State<FavoriteActivitiesSelectorDialog> createState() =>
      _FavoriteActivitiesSelectorDialogState();
}

class _FavoriteActivitiesSelectorDialogState
    extends State<FavoriteActivitiesSelectorDialog> {
  final Map<String, IconData> _activitiesWithIcons = {
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


  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedActivities);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),
        Center(
          child: Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxHeight: 550),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Selecciona tus actividades",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _activitiesWithIcons.entries.map((entry) {
                          final activity = entry.key;
                          final icon = entry.value;
                          final isSelected = _selected.contains(activity);

                          return FilterChip(
                            selected: isSelected,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon,
                                    size: 18,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black),
                                const SizedBox(width: 6),
                                Text(activity),
                              ],
                            ),
                            backgroundColor: Colors.grey.shade300,
                            selectedColor: const Color(0xFFAB82FF),
                            labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  if (_selected.length < 5) {
                                    _selected.add(activity);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text(
      "Solo puedes añadir hasta 5 actividades.",
      style: TextStyle(
        fontFamily: 'Georgia',
        fontStyle: FontStyle.italic,
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    backgroundColor: const Color(0xFFAB82FF),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 2),
  ),
);

                                  }
                                } else {
                                  _selected.remove(activity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Guardar selección"),
                      onPressed: () {
                        widget.onActivitiesSelected(_selected);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}