import 'package:flutter/material.dart';
import 'package:poetry_quest/screens/home_screen.dart';
import 'package:poetry_quest/screens/profile_screen.dart';
import 'package:poetry_quest/screens/battle_screen.dart';
import 'package:poetry_quest/screens/poem_community_screen.dart';
import 'package:poetry_quest/screens/dialogue_screen.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:provider/provider.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DialogueScreen(),
    const BattleScreen(),
    const PoemCommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<GameProvider>(context, listen: false).initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        // 同步底部导航索引
        if (provider.appTabIndex != _currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentIndex = provider.appTabIndex;
            });
          });
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              provider.setAppTab(index);
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '诗境'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'AI对话'),
              BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: '挑战'),
              BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: '我要写诗'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
            ],
          ),
        );
      },
    );
  }
}