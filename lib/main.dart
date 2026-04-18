import 'package:flutter/material.dart';
import 'package:poetry_quest/app.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:poetry_quest/utils/routes.dart';
import 'package:poetry_quest/screens/journey_screen.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/providers/game_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const PoetryQuestApp(),
    ),
  );
}

class PoetryQuestApp extends StatelessWidget {
  const PoetryQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poetry Quest · 诗境闯关',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppWrapper(),
      routes: {
        Routes.journey: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          final levelIndex = args?['levelIndex'] as int? ?? 0;
          final difficulty = args?['difficulty'] as String? ?? '简单';
          return JourneyScreen(levelIndex: levelIndex, difficulty: difficulty);
        },
      },
    );
  }
}
