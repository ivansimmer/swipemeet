import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'home_page_model.dart';
import '/flutter_flow/custom_navbar.dart';

export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    _model = FlutterFlowModel.createModel(context, () => HomePageModel());
    _fetchProfiles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _model.dispose();
    super.dispose();
  }

  // Recoger los perfiles de la bdd
  void _fetchProfiles() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').get();
        List<Map<String, dynamic>> profilesList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((data) =>
                data['email'] !=
                currentUser
                    .email) // Me aseguro de no mostrar el perfil asociado al email que esta logueado
            .toList();
        setState(() {
          profiles = profilesList;
        });
      }
    } catch (e) {
      debugPrint("Error al obtener perfiles: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar perfiles.')),
      );
    }
  }

  // Metodo para navegar entre paginas de la navbar
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

  // Metodo para mostrar el perfil anterior
  void _goToPreviousProfile() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // Metodo para mostrar el siguiente perfil
  void _goToNextProfile() {
    if (profiles.isNotEmpty && _currentPage < profiles.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // Metodo para conectar con el usuario
  void _connect() {
    // Por ahora muestro un mensaje, pero a futuro falta implementar
    if (profiles.isNotEmpty && _currentPage < profiles.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Conectando con ${profiles[_currentPage]['name']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              // Titulo header
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'SWIPEMEET',
                style: FlutterFlowTheme.swipeHeader,
              ),
            ),
            Expanded(
              child: profiles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: profiles.length,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemBuilder: (context, index) {
                        return _buildProfileCard(profiles[index]);
                      },
                    ),
            ),
            Padding(
              // Contenedor de los botones
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _goToPreviousProfile,
                    iconSize: 30,
                  ),
                  IconButton(
                    icon: Icon(Icons.link), //link y link_off
                    color: Colors.blueAccent,
                    onPressed: _connect,
                    iconSize: 40,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _goToNextProfile,
                    iconSize: 30,
                  ),
                ],
              ),
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

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    String defaultImageUrl =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    String imageUrl = profile['picture'] ?? defaultImageUrl;
    String bornDate = profile['born_date'] ?? 'Desconocido';
    int edad = 0;
    if (bornDate != 'Desconocido') {
      // Convertir la fecha en formato 'dd/mm/yyyy' a un formato compatible con DateTime
      List<String> dateParts = bornDate.split('/');
      if (dateParts.length == 3) {
        // Formato 'yyyy-mm-dd' para poder usar DateTime.parse
        String formattedDate =
            '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
        DateTime fechaNacimiento = DateTime.parse(formattedDate);

        // Obtener la fecha actual
        DateTime fechaActual = DateTime.now();

        // Calcular la diferencia en años
        edad = fechaActual.year - fechaNacimiento.year;

        // Ajustar si aún no ha cumplido años este año
        if (fechaActual.month < fechaNacimiento.month ||
            (fechaActual.month == fechaNacimiento.month &&
                fechaActual.day < fechaNacimiento.day)) {
          edad--;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 186,
              height: 262,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                  defaultImageUrl,
                  width: 186,
                  height: 262,
                  fit: BoxFit.cover),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
          Text('${profile['name'] ?? 'Desconocido'}, ${edad ?? 'Desconocido'}',
              style: FlutterFlowTheme.homePerfil),
          Text(profile['university'] ?? 'Desconocido'),
          Text(profile['studies'] ?? 'Desconocido'),
          Text(profile['location'] ?? 'Implementar ubicacion'),
        ],
      ),
    );
  }
}
