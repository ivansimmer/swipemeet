import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipemeet/models/flutter_flow_model.dart';
import 'package:swipemeet/pages/ubication_service.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = FlutterFlowModel.createModel(context, () => HomePageModel());
    _cargarUbicacion();
    _fetchProfiles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _model.dispose();
    super.dispose();
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'SWIPEMEET',
                style: FlutterFlowTheme.swipeHeader,
              ),
            ),
            Expanded(
              child: profiles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: profiles.length,
                      onPageChanged: (index) => setState(() {
                        if (index < profiles.length) {
                          _currentPage = index;
                        }
                      }),
                      itemBuilder: (context, index) {
                        if (index < profiles.length) {
                          return _buildProfileCard(profiles[index]);
                        } else {
                          return const SizedBox(); // Return an empty widget if index is out of bounds
                        }
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: (profiles.isEmpty || _currentPage == 0)
                        ? null
                        : _goToPreviousProfile,
                    iconSize: 30,
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    color: profiles.isNotEmpty &&
                            profiles[_currentPage]['isConnected']
                        ? Colors.blueAccent
                        : Colors.grey, // Usamos el campo isConnected
                    onPressed: profiles.isEmpty ? null : _connect,
                    iconSize: 40,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: (profiles.isEmpty ||
                            _currentPage >= profiles.length - 1)
                        ? null
                        : _goToNextProfile,
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
      List<String> dateParts = bornDate.split('/');
      if (dateParts.length == 3) {
        String formattedDate =
            '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
        DateTime fechaNacimiento = DateTime.parse(formattedDate);
        DateTime fechaActual = DateTime.now();
        edad = fechaActual.year - fechaNacimiento.year;
        if (fechaActual.month < fechaNacimiento.month ||
            (fechaActual.month == fechaNacimiento.month &&
                fechaActual.day < fechaNacimiento.day)) {
          edad--;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                  defaultImageUrl,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  '${profile['name'] ?? 'Desconocido'}',
                  style: FlutterFlowTheme.homePerfil,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                ', $edad',
                style: FlutterFlowTheme.homePerfil,
              ),
            ],
          ),
          Text(profile['university'] ?? 'Desconocido'),
          Text(profile['studies'] ?? 'Desconocido'),
          Text(profile['ubicacion'] ?? 'Ubicacion desconocida'),
        ],
      ),
    );
  }
}
