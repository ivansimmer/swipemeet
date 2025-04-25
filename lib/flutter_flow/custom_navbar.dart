import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      onTap: (index) async {
        await Future.delayed(const Duration(milliseconds: 300));
        onTap(index);
      },
      items: const [
        Icon(Icons.home, size: 30),
        Icon(Icons.chat, size: 30),
        Icon(Icons.person, size: 30),
      ],
      height: 60.0, // Puedes modificar la altura de la barra
      color: const Color(0xFFAB82FF), // Cambia el color de la barra
      buttonBackgroundColor: const Color(0xFFAB82FF), // Color del botón
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      animationCurve: Curves.easeInOut, // Animación de transición
      animationDuration:
          const Duration(milliseconds: 300), // Duración de la animación
    );
  }
}
