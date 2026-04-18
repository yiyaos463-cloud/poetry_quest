import 'package:flutter/material.dart';

class TeamBattleScreen extends StatelessWidget {
  const TeamBattleScreen({super.key});

  void _startMatching(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('团战匹配'),
        content: const Text('正在匹配队友（模拟）...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我要团战')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('团战模式：随机匹配队友，共同挑战诗词难题', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            // 自适应居中按钮：在窄屏缩小，在宽屏保持合适宽度
            FractionallySizedBox(
              widthFactor: 0.6,
              child: ElevatedButton.icon(
                onPressed: () => _startMatching(context),
                icon: const Icon(Icons.groups),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text('开始匹配'),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
