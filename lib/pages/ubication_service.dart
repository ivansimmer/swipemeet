import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbicacionService {
  static Future<bool> _verificarPermisos(BuildContext context) async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      await _mostrarAlerta(
        context,
        'Los servicios de ubicación están desactivados. Actívalos para continuar.',
        mostrarConfiguracion: false,
      );
      return false;
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.deniedForever) {
      await _mostrarAlerta(
        context,
        'Has denegado permanentemente los permisos de ubicación. Debes habilitarlos desde la configuración del sistema.',
        mostrarConfiguracion: true,
      );
      return false;
    }

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        await _mostrarAlerta(
          context,
          'Necesitamos acceso a tu ubicación para usar la app.',
          mostrarConfiguracion: false,
        );
        return false;
      }

      if (permiso == LocationPermission.deniedForever) {
        await _mostrarAlerta(
          context,
          'Has denegado permanentemente los permisos. Ve a la configuración para habilitarlos.',
          mostrarConfiguracion: true,
        );
        return false;
      }
    }

    return permiso == LocationPermission.always ||
        permiso == LocationPermission.whileInUse;
  }

  static Future<Position?> obtenerUbicacion(BuildContext context) async {
    bool permisosOtorgados = await _verificarPermisos(context);
    if (!permisosOtorgados) return null;

    try {
      Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitud', posicion.latitude);
      await prefs.setDouble('longitud', posicion.longitude);

      return posicion;
    } catch (e) {
      print("❌ Error obteniendo la ubicación: $e");
      return null;
    }
  }

  static Future<void> _mostrarAlerta(
    BuildContext context,
    String mensaje, {
    bool mostrarConfiguracion = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // que no se pueda cerrar con tap fuera
      builder: (context) => AlertDialog(
        title: Text('Permiso necesario'),
        content: Text(mensaje),
        actions: [
          if (mostrarConfiguracion)
            TextButton(
              child: Text('Abrir configuración'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
            ),
          TextButton(
            child: Text('Cerrar app'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  static Future<Position?> cargarUbicacionGuardada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitud = prefs.getDouble('latitud');
    double? longitud = prefs.getDouble('longitud');

    if (latitud != null && longitud != null) {
      return Position(
        latitude: latitud,
        longitude: longitud,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        timestamp: DateTime.now(),
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    return null;
  }

  static Future<String> obtenerCiudadPais(
      double latitud, double longitud) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitud&lon=$longitud&format=json&addressdetails=1';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'swipemeet-app/1.0 (contacto@tucorreo.com)' // IMPORTANTE
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['address'] != null) {
          String ciudad = data['address']['city'] ??
              data['address']['town'] ??
              data['address']['village'] ??
              'Desconocida';
          String pais = data['address']['country'] ?? 'Desconocido';
          return '$ciudad, $pais';
        } else {
          return 'Ubicación desconocida';
        }
      } else {
        throw Exception(
            'Error al obtener la ubicación: Código ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error en obtenerCiudadPais: $e");
      return 'Ubicación desconocida';
    }
  }
}
