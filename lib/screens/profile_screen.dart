import 'package:flutter/material.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/widgets/custom_app_bar.dart';
import 'package:poetry_quest/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '我的诗卡'),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          final isGuest = provider.isGuest;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.brown.shade100,
                          child: Text(
                            isGuest
                                ? '?'
                                : provider.currentUsername!
                                      .substring(0, 1)
                                      .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isGuest ? '游客' : provider.currentUsername!,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              if (isGuest)
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => const AuthScreen(),
                                    );
                                  },
                                  child: const Text('点击登录 / 注册'),
                                )
                              else
                                Text(
                                  '这个用户很懒什么都没留下～',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                        if (!isGuest)
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () async => await provider.logout(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: '完成关卡',
                        value: provider.totalCompletedLevels.toString(),
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: '才学积分',
                        value: provider.totalScore.toString(),
                        icon: Icons.star_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: '服装收集',
                        value:
                            '${provider.unlockedOutfitPaths.length}/${provider.allOutfits.length}',
                        icon: Icons.checkroom_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '📦 我的诗卡',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Consumer<GameProvider>(
                  builder: (context, provider, child) {
                    final poems = provider.collectedPoems;
                    if (poems.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              '还没有收藏的诗卡，快去闯关吧！',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: poems.map((poem) {
                        final difficulty = poem['difficulty'] ?? '简单';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        poem['title']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getDifficultyColor(difficulty),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        difficulty,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  poem['lines']!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  poem['summary']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.checkroom, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '我的装备',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Spacer(),
                            Text(
                              '${provider.unlockedOutfitPaths.length}/${provider.allOutfits.length}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: provider.allOutfits.length,
                          itemBuilder: (context, index) {
                            final outfit = provider.allOutfits[index];
                            final path = outfit['path'] as String;
                            final name = outfit['name'] as String;
                            final requiredScore = outfit['score'] as int;
                            final isUnlocked = provider.unlockedOutfitPaths
                                .contains(path);
                            final canUnlock =
                                provider.totalScore >= requiredScore;

                            Widget imageWidget = Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: canUnlock
                                    ? Colors.blue.withValues(alpha: 0.2)
                                    : Colors.grey.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock,
                                color: canUnlock ? Colors.blue : Colors.grey,
                                size: 28,
                              ),
                            );

                            if (isUnlocked) {
                              imageWidget = Hero(
                                tag: 'outfit_$path',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    path,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: isUnlocked
                                  ? () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          opaque: false,
                                          barrierDismissible: true,
                                          pageBuilder: (_, _, _) =>
                                              _OutfitDetailScreen(
                                                imagePath: path,
                                                name: name,
                                              ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : (canUnlock
                                            ? Colors.blue.withValues(alpha: 0.1)
                                            : Colors.grey.withValues(
                                                alpha: 0.1,
                                              )),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? Colors.green
                                        : (canUnlock
                                              ? Colors.blue
                                              : Colors.grey),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    imageWidget,
                                    const SizedBox(height: 8),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: isUnlocked
                                            ? Colors.green[800]
                                            : (canUnlock
                                                  ? Colors.blue[800]
                                                  : Colors.grey[700]),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (!isUnlocked) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '$requiredScore分',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: canUnlock
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '简单':
        return Colors.green;
      case '中等':
        return Colors.orange;
      case '困难':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// 装备详情放大页（修复溢出）
class _OutfitDetailScreen extends StatelessWidget {
  final String imagePath;
  final String name;

  const _OutfitDetailScreen({required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Hero(
              tag: 'outfit_$imagePath',
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
