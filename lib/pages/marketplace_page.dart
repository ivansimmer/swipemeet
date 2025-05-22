import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:swipemeet/pages/marketplace_grid.dart';
import '/flutter_flow/custom_navbar.dart';
import 'package:swipemeet/models/product_model.dart';

class MarketplacePage extends StatefulWidget {
  final String profileImageUrl;

  const MarketplacePage({super.key, required this.profileImageUrl});

  static String routeName = 'MarketplacePage';
  static String routePath = '/marketplacePage';

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _selectedIndex = 3;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _onNavItemTapped(int index) {
    final routes = {
      0: 'HomePage',
      1: 'ChatPage',
      2: 'CommunitiesPage',
      3: 'MarketplacePage',
      4: 'ProfilePage',
    };
    try {
      context.goNamed(routes[index]!);
    } catch (e) {
      print('Navigation failed: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        child: const Center(child: Text('Logo')),
      ),
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(
  Icons.add,
  color: Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black,
),

      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddProductPage()),
  );
},

    ),
  ],
),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white54),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                filled: true,
                fillColor: const Color(0xFF3A2F5B),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(child: MarketplaceGrid(searchQuery: _searchQuery)),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        profileImageUrl: widget.profileImageUrl,
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  static String routeName = 'AddProductPage';
  static String routePath = '/addProductPage';

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  static const double _cardRadius = 16.0;
  static const double _padding = 16.0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<File> _selectedImages = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    const account = "tindermonlau";
    const container = "imagenes";
    const sasToken =
        "sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2025-06-25T00:52:15Z&st=2025-04-24T16:52:15Z&spr=https,http&sig=rDyiZUrrI%2FOuotORnL3UgOCeAGSZLZdXdsJxURK1Hm8%3D";
    final List<String> imageUrls = [];

    for (final image in _selectedImages) {
      final blobName =
          "${DateTime.now().millisecondsSinceEpoch}_${image.uri.pathSegments.last}";
      final blobUrl =
          "https://$account.blob.core.windows.net/$container/$blobName?$sasToken";

      final Uri uri = Uri.parse(blobUrl);
      final request = http.Request('PUT', uri)
        ..headers.addAll({
          'Content-Type': 'application/octet-stream',
          'x-ms-blob-type': 'BlockBlob',
        })
        ..bodyBytes = await image.readAsBytes();

      final response = await request.send();
      if (response.statusCode == 201) {
        imageUrls.add(blobUrl.split('?')[0]);
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    }
    return imageUrls;
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate() || _selectedImages.isEmpty) return;

    setState(() => _isUploading = true);
    try {
      final imageUrls = await _uploadImages();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final product = ProductModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        imageUrls: imageUrls,
        createdBy: user.uid,
        timestamp: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto añadido con éxito!')),
        );
        context.goNamed('MarketplacePage');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: Colors.red[400]),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir nuevo producto',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color(0xFFAB82FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Nombre'),
              const SizedBox(height: _padding / 2),
              _buildTextField(_descriptionController, 'Descripción',
                  maxLines: 3),
              const SizedBox(height: _padding / 2),
              _buildTextField(_priceController, 'Precio (€)',
                  keyboardType: TextInputType.number),
              const SizedBox(height: _padding),
              ElevatedButton(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAB82FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_cardRadius)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Seleccionar imagen',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: _padding),
              Wrap(
                spacing: 8,
                children: _selectedImages
                    .map((img) => ClipRRect(
                          borderRadius: BorderRadius.circular(_cardRadius),
                          child: Image.file(img,
                              height: 100, width: 100, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
              const SizedBox(height: _padding),
              _isUploading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFAB82FF)))
                  : ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB82FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_cardRadius)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Añadir producto',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_cardRadius / 2),
          borderSide:
              const BorderSide(color: Color.fromARGB(211, 190, 190, 190)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_cardRadius / 2),
          borderSide:
              const BorderSide(color: Color.fromARGB(211, 190, 190, 190)),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty)
          return 'Introduce un $label válido';
        if (label == 'Precio (€)' && double.tryParse(value) == null)
          return 'Introduce un precio válido';
        return null;
      },
    );
  }
}