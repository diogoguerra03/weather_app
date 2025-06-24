import 'package:flutter/material.dart';

typedef OnNavTap = void Function(int index);

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final OnNavTap onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF362A84),
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud, size: 28),
          label: 'Weather',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt, size: 28),
          label: 'Cities',
        ),
      ],
    );
  }
}
