import 'package:flutter/material.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/widgets/custom_app_bar.dart';
import 'package:poetry_quest/utils/routes.dart';
import 'package:poetry_quest/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class LevelMapScreen extends StatelessWidget {
  final String difficulty;

  const LevelMapScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final poem = provider.selectedPoem;
        if (poem == null) {
          return const Scaffold(body: Center(child: Text('未选择诗词')));
        }
        final progress = provider.currentPoemProgress;
        final levelCount = poem.levelCount;

        return Scaffold(
          appBar: CustomAppBar(title: '大鹏·蜀地初啼'),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress != null
                            ? progress.completedLevels.where((c) => c).length / levelCount
                            : 0,
                        backgroundColor: Colors.grey.shade200,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${progress?.completedLevels.where((c) => c).length ?? 0}/$levelCount',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: List.generate(levelCount, (index) {
                        final isUnlocked = provider.isLevelUnlocked(index);
                        final isCompleted = progress?.completedLevels[index] ?? false;
                        final isLast = index == levelCount - 1;
                        final color = _getLevelColor(index);
                        return Row(
                          children: [
                            _buildLevelNode(
                              context: context,
                              index: index,
                              isUnlocked: isUnlocked,
                              isCompleted: isCompleted,
                              color: color,
                              onTap: () {
                                if (!isUnlocked) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('敬请期待'),
                                      content: const Text('该关卡正在开发中，即将开放...'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('确定'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                print('=== 点击关卡节点 ===');
                                print('关卡索引: $index');
                                print('难度: $difficulty');
                                print('用户登录状态: ${provider.isLoggedIn}');

                                if (provider.isGuest) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => const AuthScreen(),
                                  );
                                } else {
                                  provider.startLevel(index);
                                  Navigator.pushNamed(
                                    context,
                                    Routes.journey,
                                    arguments: {
                                      'levelIndex': index,
                                      'difficulty': difficulty,
                                    },
                                  );
                                }
                              },
                            ),
                            if (!isLast) _buildDashedConnector(color),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getLevelColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF5B8C6F);
      case 1:
        return const Color(0xFFD4A843);
      case 2:
        return const Color(0xFF7A8B99);
      case 3:
        return const Color(0xFFD46B4B);
      default:
        return const Color(0xFF5B8C6F);
    }
  }

  Widget _buildLevelNode({
    required BuildContext context,
    required int index,
    required bool isUnlocked,
    required bool isCompleted,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? color : (isUnlocked ? color.withOpacity(0.3) : Colors.grey.shade300),
              border: Border.all(
                color: isCompleted ? color : (isUnlocked ? color : Colors.grey),
                width: 3,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 32)
                  : (isUnlocked
                      ? Icon(Icons.auto_awesome, color: color, size: 28)
                      : const Icon(Icons.lock, color: Colors.grey, size: 28)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getLevelName(index),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? color : Colors.grey,
            ),
          ),
          Text(
            isCompleted ? '已完成' : (isUnlocked ? '可挑战' : '未解锁'),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedConnector(Color color) {
    return Container(
      width: 80,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color),
      ),
    );
  }

  String _getLevelName(int index) {
    switch (index) {
      case 0:
        return '试翼';
      case 1:
        return '乘风';
      case 2:
        return '低徊';
      case 3:
        return '重生';
      default:
        return '第${index + 1}层';
    }
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}