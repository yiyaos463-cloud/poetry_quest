import 'package:flutter/material.dart';
import 'package:poetry_quest/screens/home_screen.dart';
import 'package:poetry_quest/screens/battle_screen.dart';
import 'package:poetry_quest/screens/my_poems_screen.dart';
import 'package:poetry_quest/utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BattleScreen(),
    const MyPoemsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.inkColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.accentColor,
          unselectedItemColor: AppTheme.lightInkColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: '团战',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_outlined),
              activeIcon: Icon(Icons.edit_note),
              label: '我的诗作',
            ),
          ],
        ),
      ),
    );
  }
}