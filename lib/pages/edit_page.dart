import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swipemeet/flutter_flow/custom_navbar.dart';

class EditWidget extends StatefulWidget {
  const EditWidget({super.key});

  static String routeName = 'Edit';
  static String routePath = '/edit';

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedIndex = 2;
  bool isLoading = false;
  // Se guarda la ruta local de la imagen, asegurándonos de no tener el prefijo "file://"
  String profilePicture = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perfil actualizado correctamente")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar el perfil")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.goNamed('ProfilePage'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: const CircleAvatar(
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateUserData();
                      context.goNamed('ProfilePage');
                    },
                    child: const Text("Guardar Cambios"),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
