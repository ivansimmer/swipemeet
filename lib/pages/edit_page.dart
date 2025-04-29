import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditWidget extends StatefulWidget {
  const EditWidget({super.key});

  static String routeName = 'Edit';
  static String routePath = '/edit';

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String profilePicture = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc['name'] ?? '';
            _emailController.text = userDoc['email'] ?? '';
            profilePicture = userDoc['picture'] ?? '';
          });
        }
      } catch (e) {
        print("Error cargando datos: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'picture': profilePicture,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isLoading = true;
      });

      File imageFile = File(image.path);
      try {
        await _uploadImageToAzure(imageFile);
      } catch (e, st) {
        print("🛑 Error inesperado en _pickImage: $e");
        print("StackTrace: $st");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImageToAzure(File imageFile) async {
    final String storageAccountName = "tindermonlau";
    final String containerName = "imagenes";
    final String sasToken =
        "sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2025-06-25T00:52:15Z&st=2025-04-24T16:52:15Z&spr=https,http&sig=rDyiZUrrI%2FOuotORnL3UgOCeAGSZLZdXdsJxURK1Hm8%3D";

    final String blobName =
        "${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}";
    final String blobUrl =
        "https://$storageAccountName.blob.core.windows.net/$containerName/$blobName?$sasToken";
    print("Azure URL: $blobUrl");

    final Uri serverUrl = Uri.parse(blobUrl);

    try {
      var request = http.Request('PUT', serverUrl);

      request.headers.addAll({
        'Content-Type': 'application/octet-stream',
        'x-ms-blob-type': 'BlockBlob',
      });

      request.bodyBytes = await imageFile.readAsBytes();
      var response = await request.send();

      if (response.statusCode == 201) {
        String imageUrl =
            "https://$storageAccountName.blob.core.windows.net/$containerName/$blobName";
        print("✅ Imagen subida correctamente: $imageUrl");
        setState(() {
          profilePicture = imageUrl;
        });
      } else {
        print("❌ Fallo al subir imagen. Código: ${response.statusCode}");
        response.stream.transform(const Utf8Decoder()).listen((value) {
          print("Respuesta del servidor: $value");
        });
      }
    } catch (e, st) {
      print("🛑 Error subiendo imagen a Azure: $e");
      print("StackTrace: $st");
    }
  }

  ImageProvider _buildProfileImage() {
    if (profilePicture.isEmpty) {
      return const AssetImage('assets/default_profile.png');
    } else if (profilePicture.startsWith("http")) {
      return NetworkImage(profilePicture);
    } else {
      return FileImage(File(profilePicture));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed('ProfilePage');
            },
          ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _buildProfileImage(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Correo Electrónico",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    enabled: false, // No permitir editar el email
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _updateUserData();
                        context.goNamed('ProfilePage');
                      },
                      child: const Text("Guardar Cambios"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
