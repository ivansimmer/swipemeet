import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/main.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import 'package:swipemeet/pages/profile_detail_page.dart';
import 'package:swipemeet/pages/ubication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/custom_navbar.dart';
import 'package:http/http.dart' as http;

export 'home_page_model.dart';

const Color pink300 = Color(0xFFF06292);

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class HomePageModel extends FlutterFlowModel {
  double matchScale = 1.0;

  @override
  void dispose() {}
}

class _HomePageWidgetState extends State<HomePageWidget>
    with WidgetsBindingObserver {
  Position? ubicacion;
  String ciudadPais = '';
  bool _alertaMostrada = false;
  bool _permisoSolicitado = false;
  String picture = '';
  bool _modoIA = false;

  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> profiles = [];
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  double _swipeOffset = 0.0;
  bool _isFetching = false;
  bool _cancelarIA = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = FlutterFlowModel.createModel(context, () => HomePageModel());

    _modoIA = false; // ← Forzar modo básico al inicio
    _fetchProfiles(); // ← Cargar perfiles por coincidencias simples

    _cargarUbicacion();
    _enviarEdadAFirebaseAnalytics();
    logScreenView('HomePage');
    _loadCurrentUserProfile();
    asignarUsuarioAComunidades();
    _pageController.addListener(() {
      setState(() {
        _swipeOffset =
            _pageController.offset / MediaQuery.of(context).size.width;
      });
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted || profiles.isNotEmpty) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Cargando...'),
          content: const Text(
              'Tarda más de lo normal en cargar. Verifica tu conexión a internet.'),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _cargarPerfilesDesdeCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_profiles');

    if (cachedData != null) {
      try {
        final List<dynamic> data = jsonDecode(cachedData);
        if (!mounted) return;
        setState(() {
          profiles = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      } catch (e) {
        debugPrint("⚠️ Error al cargar perfiles en caché: $e");
      }
    }
  }

  Future<void> asignarUsuarioAComunidades() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return;

    final userData = doc.data()!;
    final escuela = userData['university'] ?? '';
    final estudio = userData['studies'] ?? '';

    final batch = FirebaseFirestore.instance.batch();

    Future<void> agregarASala(String comunidadId) async {
      final ref =
          FirebaseFirestore.instance.collection('communities').doc(comunidadId);
      final snap = await ref.get();
      if (snap.exists) {
        final users = List<String>.from(snap.data()?['users'] ?? []);
        if (!users.contains(user.uid)) {
          batch.update(ref, {
            'users': FieldValue.arrayUnion([user.uid]),
          });
        }
      }
    }

    if (escuela.isNotEmpty) {
      await agregarASala(escuela);
    }

    if (estudio.isNotEmpty) {
      await agregarASala(estudio);
    }

    await batch.commit();
  }

  Future<void> _loadCurrentUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        if (!mounted) return;
        setState(() {
          picture = doc['picture'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("❌ Error al cargar perfil del usuario: $e");
    }
  }

  Future<void> _establecerRangoEdadUsuario(int edad) async {
    String rango = 'desconocido';

    if (edad < 18) {
      rango = 'menor_de_18';
    } else if (edad <= 25) {
      rango = '18_25';
    } else if (edad <= 35) {
      rango = '26_35';
    } else if (edad <= 45) {
      rango = '36_45';
    } else if (edad <= 60) {
      rango = '46_60';
    } else {
      rango = 'mayor_60';
    }

    await analytics.setUserProperty(name: 'age_range', value: rango);
    debugPrint('🧾 Rango de edad establecido: $rango');
  }

  Future<void> _enviarEdadAFirebaseAnalytics() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String bornDate = userDoc['born_date'] ?? '';
        int edad = 0;

        if (bornDate.isNotEmpty) {
          List<String> dateParts = bornDate.split('/');
          if (dateParts.length == 3) {
            String formattedDate =
                '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
            DateTime birthDate = DateTime.parse(formattedDate);
            DateTime today = DateTime.now();
            edad = today.year - birthDate.year;
            if (today.month < birthDate.month ||
                (today.month == birthDate.month && today.day < birthDate.day)) {
              edad--;
            }
          }
        }

        if (edad > 0) {
          await analytics.logEvent(
            name: 'user_age',
            parameters: {'age': edad},
          );

          await _establecerRangoEdadUsuario(edad);

          debugPrint('📊 Edad enviada a Firebase Analytics: $edad');
        }
      }
    } catch (e) {
      debugPrint("❌ Error al enviar edad a Analytics: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _crearSalaChatSiNoExiste(
      String currentUid, String targetUid) async {
    try {
      final chatsRef = FirebaseFirestore.instance.collection('rooms');

      // Buscar una sala existente con estos dos usuarios
      final existingChat = await chatsRef
          .where('participantIds', arrayContains: currentUid)
          .get();

      bool salaExiste = false;
      for (var doc in existingChat.docs) {
        final List participantIds = doc['participantIds'];
        if (participantIds.contains(targetUid) && participantIds.length == 2) {
          salaExiste = true;
          break;
        }
      }

      // Si no existe, crearla
      if (!salaExiste) {
        await chatsRef.add({
          'participantIds': [currentUid, targetUid],
          'lastMessage': '',
          'lastTimestamp': FieldValue.serverTimestamp(),
          'seenBy': [false, false],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'name': 'Sala de Chat',
        });
        debugPrint("✅ Sala de chat creada");
      } else {
        debugPrint("ℹ️ Sala de chat ya existe");
      }
    } catch (e) {
      debugPrint("❌ Error al crear/verificar sala de chat: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _cargarUbicacion();
    }
  }

  Future<void> _actualizarUbicacionEnFirestore(String ciudadPais) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'ubicacion': ciudadPais});
        debugPrint("✅ Ubicación actualizada en Firestore: $ciudadPais");
      }
    } catch (e) {
      debugPrint("❌ Error al actualizar la ubicación en Firestore: $e");
    }
  }

  Future<void> _cargarUbicacion() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      // Si no se tiene permiso, solo entonces mostrar el diálogo
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!_permisoSolicitado) {
          _mostrarDialogoPermisos(); // Solo si no se ha solicitado aún
        }
        return;
      }

      // Si ya se tiene el permiso
      if (permission == LocationPermission.deniedForever) {
        _mostrarDialogoPermisos(permanente: true);
        return;
      }

      // Intentar cargar ubicación
      Position? ubicacionGuardada =
          await UbicacionService.cargarUbicacionGuardada();

      if (ubicacionGuardada != null) {
        if (!mounted) return;
        setState(() => ubicacion = ubicacionGuardada);
        ciudadPais = await UbicacionService.obtenerCiudadPais(
          ubicacion!.latitude,
          ubicacion!.longitude,
        );
      } else {
        Position? nuevaUbicacion =
            await UbicacionService.obtenerUbicacion(context);
        if (nuevaUbicacion != null) {
          if (!mounted) return;
          setState(() => ubicacion = nuevaUbicacion);
          ciudadPais = await UbicacionService.obtenerCiudadPais(
            nuevaUbicacion.latitude,
            nuevaUbicacion.longitude,
          );
        }
      }

      // Actualizar ubicación en Firestore si la ciudad ha sido obtenida
      if (ciudadPais.isNotEmpty) {
        await _actualizarUbicacionEnFirestore(ciudadPais);
      }

      // Enviar la ubicación a Firebase Analytics
      if (ciudadPais.isNotEmpty) {
        await analytics.logEvent(
          name: 'user_location',
          parameters: {
            'city_country': ciudadPais,
          },
        );
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("❌ Error al cargar ubicación: $e");
    }
  }

  void _mostrarDialogoPermisos({bool permanente = false}) {
    if (_alertaMostrada) return;
    _alertaMostrada = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de ubicación'),
        content: Text(permanente
            ? 'Los permisos de ubicación están deshabilitados permanentemente. Debes habilitarlos desde la configuración del sistema.'
            : 'Necesitamos permisos de ubicación para continuar. Por favor, concédelos.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _alertaMostrada = false;
              if (!permanente) {
                setState(() {
                  _permisoSolicitado =
                      true; // Marcar que hemos solicitado el permiso
                });
                Geolocator.requestPermission().then((permission) {
                  _permisoSolicitado = false; // Resetear
                  if (permission == LocationPermission.denied) {
                    _mostrarDialogoPermisos(); // Si se deniega, mostrar la alerta nuevamente
                  } else if (permission == LocationPermission.deniedForever) {
                    _mostrarDialogoPermisos(permanente: true);
                  } else {
                    _cargarUbicacion(); // Proceder con la carga de ubicación
                  }
                });
              }
            },
            child: const Text('OK'),
          ),
          if (permanente)
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
                _alertaMostrada = false;
              },
              child: const Text('Abrir ajustes'),
            ),
        ],
      ),
    );
  }

  // En tu HomePageWidget dentro de _fetchProfiles()
// ... [código inicial sin cambios anteriores]

// Sustituir _fetchProfiles con la nueva lógica
  Future<void> _fetchProfiles() async {
  if (_isFetching) return;
  _isFetching = true;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final List<Map<String, dynamic>> perfilesSimples =
        await _fetchSimpleMatches(uid);
    if (!mounted) return;
    setState(() {
      profiles = perfilesSimples;
    });

  } catch (e) {
    debugPrint("Error al cargar perfiles simples: $e");
  } finally {
    _isFetching = false;
  }
}

  Widget buildRoundIconButton({
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  Border? border,
  required VoidCallback? onTap,
  String? tooltip,
  double customSize = 82, // valor por defecto
}) {
  return Tooltip(
    message: tooltip ?? '',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: customSize,
        height: customSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Icon(icon, color: iconColor, size: 36),
      ),
    ),
  );
}

  Future<List<String>> _obtenerUidsConectados(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    return List<String>.from(data?['connections'] ?? []);
  }

  Future<void> _fetchIAProfiles() async {
  if (_isFetching) return;
  _isFetching = true;
  _cancelarIA = false; // Reinicia la bandera al empezar

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final connectedUids = await _obtenerUidsConectados(uid);

    final apiUrl = 'https://recomendador-ia-g04z.onrender.com/recomendar';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid}),
    );

    if (_cancelarIA || !mounted) return; // Cancelación aquí

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cached_profiles', jsonEncode(data));

      if (data.isNotEmpty) {
        if (_cancelarIA || !mounted) return; // Verifica otra vez
        setState(() {
          profiles = data
              .map((e) => Map<String, dynamic>.from(e))
              .where((e) => !connectedUids.contains(e['uid']))
              .toList();
        });

        if (context.mounted && !_cancelarIA) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Perfiles recomendados actualizados por IA ✨"),
              backgroundColor: Color(0xFFAB82FF),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  } catch (e) {
    debugPrint("Error al cargar perfiles IA: $e");
  } finally {
    _isFetching = false;
  }
}


// Nuevo método: coincidencias simples previas
  Future<List<Map<String, dynamic>>> _fetchSimpleMatches(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) return [];

      final connectedUids = await _obtenerUidsConectados(uid);
      final userUniversity = data['university'];
      final userStudies = data['studies'];
      final userActivities =
          List<String>.from(data['favorite_activities'] ?? []);

      final query = FirebaseFirestore.instance.collection('users');
      final snapshot = await query.get();
      final results = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
  if (doc.id == uid || connectedUids.contains(doc.id)) continue;

  final d = doc.data();
  int coincidencias = 0;
  if (d['university'] == userUniversity) coincidencias++;
  if (d['studies'] == userStudies) coincidencias++;
  coincidencias += List<String>.from(d['favorite_activities'] ?? [])
      .where((actividad) => userActivities.contains(actividad))
      .length;

  if (coincidencias > 0) {
    results.add({
      'uid': doc.id,
      'name': d['name'] ?? 'Sin nombre',
      'university': d['university'],
      'studies': d['studies'],
      'ubicacion': d['ubicacion'],
      'picture': d['picture'],
      'born_date': d['born_date'],
      'academic_interests': d['academic_interests'],
      'favorite_activities': d['favorite_activities'],
      'similarity': 0.0,
      'puntuacion': coincidencias, // añadimos puntuación
    });
  }
}

// 🔽 Ordenar antes de devolver
results.sort((a, b) => (b['puntuacion'] as int).compareTo(a['puntuacion'] as int));
return results;

    } catch (e) {
      debugPrint("Error en coincidencias simples: $e");
      return [];
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
      case 2:
        context.goNamed('CommunitiesPage');
        break;
      case 3:
      context.goNamed(
        'MarketplacePage',
        extra: {
          'profileImageUrl': picture.isNotEmpty
              ? picture
              : 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg',
        },
      );
      break;  
      case 4:
        context.goNamed('ProfilePage');
        break;
    }
  }
  void _goToPreviousProfile() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _connect() async {
    if (profiles.isNotEmpty && _currentPage < profiles.length) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String currentUid = currentUser?.uid ?? '';
      String targetUid = profiles[_currentPage]['uid'] ?? '';

      if (targetUid.isEmpty) {
        debugPrint("❌ El UID del perfil de destino es nulo o vacío");
        return; // Aquí salimos si el UID es vacío
      }

      try {
        DocumentReference currentUserDoc =
            FirebaseFirestore.instance.collection('users').doc(currentUid);
        DocumentReference targetUserDoc =
            FirebaseFirestore.instance.collection('users').doc(targetUid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final currentSnapshot = await transaction.get(currentUserDoc);
          final targetSnapshot = await transaction.get(targetUserDoc);

          List currentConnections =
              List.from(currentSnapshot['connections'] ?? []);
          List targetConnections =
              List.from(targetSnapshot['connections'] ?? []);

          if (!currentConnections.contains(targetUid)) {
            currentConnections.add(targetUid);
            transaction.update(currentUserDoc, {
              'connections': currentConnections,
            });
          }

          if (!targetConnections.contains(currentUid)) {
            targetConnections.add(currentUid);
            transaction.update(targetUserDoc, {
              'connections': targetConnections,
            });
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('¡Conectado con ${profiles[_currentPage]['name']}!')),
        );

        // Actualiza el estado de la conexión para el perfil conectado
        setState(() {
          profiles[_currentPage]['isConnected'] = true;
        });

        await _crearSalaChatSiNoExiste(currentUid, targetUid);
      } catch (e) {
        debugPrint("❌ Error al conectar: $e");
      }
    }
  }

  void _goToNextProfile() {
    if (profiles.isNotEmpty && _currentPage < profiles.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // ... (todo el código anterior sin cambios)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
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
            IconButton(
              icon: Icon(
                Icons.lightbulb,
                color: _modoIA ? Colors.amber.shade800 : Colors.red.shade900,
              ),
              tooltip: _modoIA ? 'Modo IA activado' : 'Modo coincidencias rápidas',
              onPressed: () async {
  final prefs = await SharedPreferences.getInstance();
  final nuevoModo = !_modoIA;

  setState(() {
    _modoIA = nuevoModo;
    _cancelarIA = !nuevoModo; // Si se desactiva IA, cancelamos su carga
    profiles = [];
  });

  prefs.setBool('modoIA', nuevoModo);

  if (nuevoModo) {
    _fetchIAProfiles(); // solo si no fue cancelado
  } else {
    _fetchProfiles(); // vuelve a cargar simple
  }
},

            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            profiles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchProfiles,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: profiles.length,
                      onPageChanged: (index) => setState(() {
                        _currentPage = index;
                      }),
                      itemBuilder: (context, index) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..rotateZ((_swipeOffset - index) * 0.05),
                          alignment: Alignment.center,
                          child: _buildProfileCard(profiles[index]),
                        );
                      },
                    ),
                  ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildBottomControls(),
            ),
          ],
        ),
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

  Widget _buildBottomControls() {
    if (profiles.isEmpty) return const SizedBox.shrink();

    final isConnected = profiles[_currentPage]['isConnected'] ?? false;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: AnimatedScale(
          scale: _model.matchScale,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: buildRoundIconButton(
            icon: Icons.school,
            iconColor: Colors.green[800]!,
            backgroundColor: Colors.green.withOpacity(0.2),
            tooltip: 'Conectar',
            customSize: 82,
            onTap: (profiles[_currentPage]['isConnected'] ?? false)
                ? null
                : () async {
                    setState(() => _model.matchScale = 1.4);
                    _connect();
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (mounted) {
                      setState(() => _model.matchScale = 1.0);
                    }
                  },
          ),
        ),
      ),
    );
  }

// ... (resto del código permanece igual)




  Widget _buildProfileCard(Map<String, dynamic> profile) {
    String defaultImageUrl =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    String imageUrl = profile['picture'] ?? defaultImageUrl;
    String bornDate = profile['born_date'] ?? 'Desconocido';
    int edad = 0;

    if (bornDate != 'Desconocido') {
      List<String> dateParts = bornDate.split('/');
      if (dateParts.length == 3) {
        String formattedDate =
            '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
        DateTime birthDate = DateTime.parse(formattedDate);
        DateTime today = DateTime.now();
        edad = today.year - birthDate.year;
        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          edad--;
        }
      }
    }

    double similarity = (profile['similarity'] ?? 0.0) as double;
    int porcentaje = (similarity * 100).round();

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.95,
              child: ProfileDetailPageWidget(profile: profile),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.73,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    defaultImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile['name'] ?? 'Desconocido'}, $edad',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            profile['studies'] ?? 'Estudios no especificados',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            profile['ubicacion'] ?? 'Ubicación no disponible',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.apartment, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            profile['university'] ?? 'Universidad desconocida',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}