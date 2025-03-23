import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  HomeAppBar({required this.currentIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contacts),
          label: "Contact",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts),
          label: "Manager",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      selectedItemColor: Colors.blue.shade400,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
