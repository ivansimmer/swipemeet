import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String profileImageUrl;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      onTap: (index) async {
        await Future.delayed(const Duration(milliseconds: 300));
        onTap(index);
      },
      items: [
        const Icon(Icons.home, size: 30),
        const Icon(Icons.chat, size: 30),
        const Icon(Icons.groups, size: 30),
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(profileImageUrl),
          backgroundColor: Colors.transparent,
        ),
      ],
      height: 60.0,
      color: const Color(0xFFAB82FF),
      buttonBackgroundColor: const Color(0xFFAB82FF),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}