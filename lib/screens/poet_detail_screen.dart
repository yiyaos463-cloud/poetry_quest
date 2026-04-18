import 'package:flutter/material.dart';
import 'package:poetry_quest/models/poet.dart';
import 'package:poetry_quest/models/poem.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/screens/level_map_screen.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class PoetDetailScreen extends StatefulWidget {
  final Poet poet;

  const PoetDetailScreen({super.key, required this.poet});

  @override
  State<PoetDetailScreen> createState() => _PoetDetailScreenState();
}

class _PoetDetailScreenState extends State<PoetDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      if (widget.poet.audioAsset != null) {
        try {
          await _audioPlayer.play(
            AssetSource(widget.poet.audioAsset!.replaceFirst('assets/', '')),
          );
          setState(() => _isPlaying = true);
        } catch (e) {
          _showCenterDialog('提示', '音频文件暂未准备好');
        }
      } else {
        _showCenterDialog('提示', '音频文件暂未准备好');
      }
    }
  }

  void _showCenterDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  List<Poem> _getPoemsByDifficulty(String difficulty) {
    return poemsData
        .where((p) => p.poetId == widget.poet.id && p.difficulty == difficulty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.paperColor,
              AppTheme.lightInkColor.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppTheme.paperColor.withValues(alpha: 0.9),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.inkColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppTheme.inkColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '诗人详情',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.inkColor,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildPoetHeader(),
                    ),
                    _buildDifficultyButtons(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoetHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 完整显示诗人形象
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.poet.imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.poet.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.inkColor,
            ),
          ),
          Text(
            widget.poet.subtitle,
            style: TextStyle(fontSize: 16, color: AppTheme.accentColor),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _toggleAudio,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.inkColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: AppTheme.inkColor,
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isPlaying ? '播放中...' : '听诗人自述',
                    style: TextStyle(color: AppTheme.inkColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.poet.description,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.lightInkColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择难度开始闯关',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.inkColor,
            ),
          ),
          const SizedBox(height: 14),
          _buildDifficultyCard(
            difficulty: '简单',
            poems: _getPoemsByDifficulty('简单'),
            color: const Color(0xFF7CB342),
            icon: Icons.looks_one,
            description: '5首诗',
          ),
          const SizedBox(height: 10),
          _buildDifficultyCard(
            difficulty: '中等',
            poems: _getPoemsByDifficulty('中等'),
            color: const Color(0xFFFFA726),
            icon: Icons.looks_two,
            description: '5首诗',
          ),
          const SizedBox(height: 10),
          _buildDifficultyCard(
            difficulty: '困难',
            poems: _getPoemsByDifficulty('困难'),
            color: const Color(0xFFE53935),
            icon: Icons.looks_3,
            description: '5首诗',
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard({
    required String difficulty,
    required List<Poem> poems,
    required Color color,
    required IconData icon,
    required String description,
  }) {
    // 检查是否有可用的峨眉山月歌
    final emeiPoems = poems
        .where((p) => p.title == '峨眉山月歌' && p.levelCount > 0)
        .toList();
    final hasEmei = emeiPoems.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (!hasEmei) {
          _showCenterDialog('提示', '《峨眉山月歌》$difficulty难度正在开发中，敬请期待！');
          return;
        }
        _startChallenge(emeiPoems.first, difficulty);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    hasEmei ? '《峨眉山月歌》已开放' : '敬请期待',
                    style: TextStyle(
                      fontSize: 12,
                      color: hasEmei ? AppTheme.lightInkColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  void _startChallenge(Poem poem, String difficulty) {
    Provider.of<GameProvider>(context, listen: false).selectPoem(poem);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LevelMapScreen(difficulty: difficulty)),
    );
  }
}