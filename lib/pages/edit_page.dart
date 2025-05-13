// archivo completo con ajustes
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipemeet/pages/favorite_activities_selector.dart';
import 'package:swipemeet/pages/spotify_search_page.dart';

class EditWidget extends StatefulWidget {
  const EditWidget({super.key});

  static String routeName = 'Edit';
  static String routePath = '/edit';

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _studiesController = TextEditingController();
  final TextEditingController _academicInterestsController =
      TextEditingController();
  final TextEditingController _academicInterestInputController =
      TextEditingController();
  final FocusNode _tagFocusNode = FocusNode();

  List<String> _academicInterests = [];
  final List<String> _selectedActivities = [];

  DateTime? _birthDate;

  bool isLoading = false;
  List<String> photoUrls = ['', '', '', '', ''];
  String _favoriteSong = '';
  String _favoriteSong_Image = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _tagFocusNode.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _universityController.dispose();
    _studiesController.dispose();
    _academicInterestsController.dispose();
    _academicInterestInputController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
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
        duration: const Duration(seconds: 2), // ⏱ Duración reducida
      ),
    );
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          _nameController.text = doc['name'] ?? '';
          _descriptionController.text = doc['description'] ?? '';
          _universityController.text = doc['university'] ?? '';
          _studiesController.text = doc['studies'] ?? '';
          final rawInterests = doc['academic_interests'];
          if (rawInterests is String) {
            _academicInterests = rawInterests
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
          } else if (rawInterests is List) {
            _academicInterests = List<String>.from(rawInterests);
          }
          final rawActivities = doc['favorite_activities'];
          if (rawActivities is List) {
            _selectedActivities.addAll(List<String>.from(rawActivities));
          } else if (rawActivities is String) {
            _selectedActivities.addAll(rawActivities
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty));
          }

          photoUrls[0] = doc['picture'] ?? '';
          photoUrls[1] = doc['photo1'] ?? '';
          photoUrls[2] = doc['photo2'] ?? '';
          photoUrls[3] = doc['photo3'] ?? '';
          photoUrls[4] = doc['photo4'] ?? '';
          final born = doc['born_date'];
          _favoriteSong = doc['favorite_song'] ?? '';
          _favoriteSong_Image = doc['favorite_song_image'] ?? '';

          if (born != null && born.toString().isNotEmpty) {
            final parts = born.split('/');
            if (parts.length == 3) {
              _birthDate = DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );
            }
          }
        }
      } catch (e) {
        print('Error cargando datos: $e');
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final formattedDate = _birthDate != null
          ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}'
          : '';

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'university': _universityController.text,
        'studies': _studiesController.text,
        'academic_interests': _academicInterests,
        'favorite_activities': _selectedActivities,
        'born_date': formattedDate,
        'picture': photoUrls[0],
        'photo1': photoUrls[1],
        'photo2': photoUrls[2],
        'photo3': photoUrls[3],
        'photo4': photoUrls[4],
        'description': _descriptionController.text,
        'favorite_song': _favoriteSong,
        'favorite_song_image': _favoriteSong_Image,

      }, SetOptions(merge: true));
    }
  }

  Future<void> _pickAndUploadPhoto(int index) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
          builder: (_) => ImageCropOverlay(imagePath: image.path)),
    );

    if (result == null) return;

    setState(() => isLoading = true);
    try {
      final String url = await _uploadToAzure(result);
      if (!mounted) return;
      setState(() {
        photoUrls[index] = url;
      });
    } catch (e) {
      print("🛑 Error subiendo: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<String> _uploadToAzure(File imageFile) async {
    const account = "tindermonlau";
    const container = "imagenes";
    const sasToken =
        "sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2025-06-25T00:52:15Z&st=2025-04-24T16:52:15Z&spr=https,http&sig=rDyiZUrrI%2FOuotORnL3UgOCeAGSZLZdXdsJxURK1Hm8%3D";

    final String blobName =
        "${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}";
    final String blobUrl =
        "https://$account.blob.core.windows.net/$container/$blobName?$sasToken";

    final Uri uri = Uri.parse(blobUrl);
    final request = http.Request('PUT', uri)
      ..headers.addAll({
        'Content-Type': 'application/octet-stream',
        'x-ms-blob-type': 'BlockBlob',
      })
      ..bodyBytes = await imageFile.readAsBytes();

    final response = await request.send();
    if (response.statusCode == 201) {
      return "https://$account.blob.core.windows.net/$container/$blobName";
    } else {
      throw Exception("Falló la subida");
    }
  }

  void _showImageDialog(String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (_) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goNamed('ProfilePage');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Editar Perfil"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goNamed('ProfilePage'),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text("Foto de Perfil",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () => _pickAndUploadPhoto(0),
                      onLongPress: photoUrls[0].isNotEmpty
                          ? () => _showImageDialog(photoUrls[0])
                          : null,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: photoUrls[0].isNotEmpty
                            ? NetworkImage(photoUrls[0])
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: photoUrls[0].isEmpty
                            ? const Icon(Icons.person,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Tus fotos",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                    children: List.generate(4, (i) {
                      final index = i + 1;
                      final url = photoUrls[index];
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _pickAndUploadPhoto(index),
                            onLongPress: url.isNotEmpty
                                ? () => _showImageDialog(url)
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: url.isEmpty
                                  ? const Center(
                                      child: Icon(Icons.add_a_photo,
                                          size: 28, color: Colors.grey),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                      ),
                                    ),
                            ),
                          ),
                          if (url.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    photoUrls[index] = '';
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE91E63),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  _buildStyledTextField(
                    context: context,
                    controller: _nameController,
                    label: "Nombre",
                  ),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                    context: context,
                    controller: _descriptionController,
                    label: "Descripción",
                    maxLines: 3,
                    maxLength: 200,
                    hint: "Ej. Me gusta viajar y conocer gente nueva",
                  ),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                    context: context,
                    controller: _universityController,
                    label: "Escuela",
                  ),
                  const SizedBox(height: 16),
                  _buildStyledTextField(
                    context: context,
                    controller: _studiesController,
                    label: "Estudios",
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _birthDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: _buildStyledTextField(
                        context: context,
                        controller: TextEditingController(
                          text: _birthDate != null
                              ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}'
                              : '',
                        ),
                        label: "Fecha de nacimiento",
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Intereses académicos",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              children: _academicInterests.map((interest) {
                                return Chip(
                                  label: Text(interest,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: const Color(0xFFAB82FF),
                                  deleteIcon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onDeleted: () {
                                    setState(() {
                                      _academicInterests.remove(interest);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            if (_academicInterests.length < 5)
                              TextField(
                                controller: _academicInterestInputController,
                                focusNode: _tagFocusNode,
                                decoration: const InputDecoration(
                                  hintText: "Añade un interés y pulsa Enter",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                                onSubmitted: (value) {
                                  final trimmed = value.trim();

                                  if (trimmed.isEmpty) return;

                                  if (_academicInterests.length >= 5) {
                                    _showError(
                                        "Solo puedes añadir hasta 5 intereses.");
                                    return;
                                  }

                                  final validFormat =
                                      RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$');
                                  if (!validFormat.hasMatch(trimmed)) {
                                    _showError(
                                        "Solo se permiten letras y espacios. Sin números ni símbolos.");
                                    return;
                                  }

                                  final wordCount =
                                      trimmed.split(RegExp(r'\s+')).length;
                                  if (wordCount > 3) {
                                    _showError(
                                        "Cada interés puede tener como máximo 3 palabras.");
                                    return;
                                  }

                                  if (_academicInterests.contains(trimmed)) {
                                    _showError("Este interés ya fue añadido.");
                                    return;
                                  }

                                  setState(() {
                                    _academicInterests.add(trimmed);
                                    _academicInterestInputController.clear();
                                  });

                                  FocusScope.of(context)
                                      .requestFocus(_tagFocusNode);
                                },
                              ),
                          ],
                        ),
                      ),
                      // Contador fuera del InputDecorator
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: Text(
                            "${_academicInterests.length} / 5",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 📌 Añadir esto en las variables de estado (arriba en la clase)

// 📌 Sustituir el bloque de "Actividades favoritas" por este:
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => FavoriteActivitiesSelectorDialog(
                          selectedActivities: _selectedActivities,
                          onActivitiesSelected: (selected) {
                            setState(() {
                              _selectedActivities
                                ..clear()
                                ..addAll(selected);
                            });
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Actividades favoritas",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedActivities.map((activity) {
                      return Chip(
                        label: Text(activity,
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFFAB82FF),
                        deleteIcon:
                            const Icon(Icons.close, color: Colors.white),
                        onDeleted: () {
                          setState(() {
                            _selectedActivities.remove(activity);
                          });
                        },
                      );
                    }).toList(),
                  ),const SizedBox(height: 16),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text("Canción favorita",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    IconButton(
      icon: const Icon(Icons.add, color: Color(0xFFAB82FF)),
      onPressed: () async {
        final result = await Navigator.push<Map<String, String>>(
  context,
  MaterialPageRoute(builder: (_) => const SpotifySearchPage()),
);

if (result != null) {
  setState(() {
    _favoriteSong = result['title'] ?? '';
    _favoriteSong_Image = result['image'] ?? '';
  });
}

      },
    ),
  ],
),
if (_favoriteSong.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(_favoriteSong,
        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
  ),


                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.trim().isEmpty) {
                          _showError("El nombre es obligatorio.");
                          return;
                        }
                        if (_descriptionController.text.trim().isEmpty) {
                          _showError("La descripción es obligatoria.");
                          return;
                        }
                        if (photoUrls[0].isEmpty) {
                          _showError("Debes subir una foto de perfil.");
                          return;
                        }
                        final extraPhotos = photoUrls
                            .sublist(1)
                            .where((url) => url.isNotEmpty)
                            .length;
                        if (extraPhotos < 2) {
                          _showError(
                              "Debes subir al menos 2 fotos adicionales.");
                          return;
                        }
                        if (_universityController.text.trim().isEmpty) {
                          _showError("La escuela es obligatoria.");
                          return;
                        }
                        if (_studiesController.text.trim().isEmpty) {
                          _showError("Los estudios son obligatorios.");
                          return;
                        }
                        if (_birthDate == null) {
                          _showError(
                              "Debes seleccionar tu fecha de nacimiento.");
                          return;
                        }

                        await _updateUserData();
                        if (!mounted) return;
                        context.goNamed('ProfilePage');
                      },
                      child: const Text("Guardar Cambios"),
                    ),
                  )
                ],
              ),
      ),
    );
  }

// 🧱 Campo reutilizable con estilo moderno
  Widget _buildStyledTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}

class ImageCropOverlay extends StatefulWidget {
  final String imagePath;

  const ImageCropOverlay({super.key, required this.imagePath});

  @override
  State<ImageCropOverlay> createState() => _ImageCropOverlayState();
}

class _ImageCropOverlayState extends State<ImageCropOverlay> {
  final GlobalKey _repaintKey = GlobalKey();

  Future<void> _cropAndReturn() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/cropped_image.png')
          .writeAsBytes(pngBytes);

      if (!mounted) return;
      Navigator.pop(context, file);
    } catch (e) {
      print("Error al recortar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajusta y recorta")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _repaintKey,
                child: ClipRect(
                  child: Container(
                    width: 300,
                    height: 300,
                    color: Colors.black,
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child:
                          Image.file(File(widget.imagePath), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _cropAndReturn,
            child: const Text("Recortar imagen"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}