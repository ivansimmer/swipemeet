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
import 'home_page_model.dart';
import '/flutter_flow/custom_navbar.dart';

export 'home_page_model.dart';

const Color pink300 = Color(0xFFF06292);

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with WidgetsBindingObserver {
  Position? ubicacion;
  String ciudadPais = '';
  bool _alertaMostrada = false;
  bool _permisoSolicitado = false;

  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> profiles = [];
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  double _swipeOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = FlutterFlowModel.createModel(context, () => HomePageModel());
    _cargarUbicacion();
    _fetchProfiles();
    _pageController.addListener(() {
      setState(() {
        _swipeOffset =
            _pageController.offset / MediaQuery.of(context).size.width;
      });
    });
    _enviarEdadAFirebaseAnalytics();
    logScreenView('HomePage');
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
        setState(() => ubicacion = ubicacionGuardada);
        ciudadPais = await UbicacionService.obtenerCiudadPais(
          ubicacion!.latitude,
          ubicacion!.longitude,
        );
      } else {
        Position? nuevaUbicacion =
            await UbicacionService.obtenerUbicacion(context);
        if (nuevaUbicacion != null) {
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

  Future<void> _fetchProfiles() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').get();
        List<Map<String, dynamic>> profilesList = snapshot.docs
            .where((doc) => doc['email'] != currentUser.email)
            .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id;
          return data;
        }).toList();

        // Verifying connections
        for (var profile in profilesList) {
          String targetUid = profile['uid'];
          DocumentSnapshot targetUserDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(targetUid)
              .get();
          List targetConnections = targetUserDoc['connections'] ?? [];
          profile['isConnected'] = targetConnections.contains(currentUser.uid);
        }

        setState(() {
          profiles = profilesList; // Only update the list once data is fetched
        });
      }
    } catch (e) {
      debugPrint("Error al obtener perfiles: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('¡Ha habido un error al cargar los perfiles!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            profiles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
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
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildBottomControls(),
            ),
            Positioned(
              top: -55,
              left: 10,
              child: Image.network(
                'https://tindermonlau.blob.core.windows.net/imagenes/logo_swipe.png',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                  child: const Center(child: Text('Logo unavailable')),
                ),
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

  Widget _buildBottomControls() {
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 30, color: iconColor),
          onPressed: (profiles.isEmpty || _currentPage == 0)
              ? null
              : _goToPreviousProfile,
        ),
        const SizedBox(width: 30),
        IconButton(
          icon: Icon(
            Icons.link,
            size: 50,
            color: profiles.isNotEmpty && profiles[_currentPage]['isConnected']
                ? Colors.blueAccent
                : Colors.grey,
          ),
          onPressed: profiles.isEmpty ? null : _connect,
        ),
        const SizedBox(width: 30),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 30, color: iconColor),
          onPressed: (profiles.isEmpty || _currentPage >= profiles.length - 1)
              ? null
              : _goToNextProfile,
        ),
      ],
    );
  }

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

    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final subTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

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
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    defaultImageUrl,
                    width: 400,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile['name'] ?? 'Desconocido'}, $edad',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.alternate_email, color: subTextColor),
                    const SizedBox(width: 4),
                    Text(
                      profile['university'] ?? 'Desconocido',
                      style: TextStyle(color: subTextColor, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: subTextColor),
                    const SizedBox(width: 4),
                    Text(
                      profile['ubicacion'] ?? 'Ubicación desconocida',
                      style: TextStyle(color: subTextColor, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.school, color: subTextColor),
                    const SizedBox(width: 4),
                    Text(
                      profile['studies'] ?? 'Desconocido',
                      style: TextStyle(color: subTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
