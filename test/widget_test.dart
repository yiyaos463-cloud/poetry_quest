import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poetry_quest/main.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Poetry Quest app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.2
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => GameProvider(),
        child: const PoetryQuestApp(),
      ),
    );

    // Verify that the home screen shows "诗境 · 寻仙"
    expect(find.text('诗境 · 寻仙'), findsOneWidget);
    expect(find.text('开始闯关'), findsOneWidget);
  });
}
