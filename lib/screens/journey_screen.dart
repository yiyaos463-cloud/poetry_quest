import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:poetry_quest/data/poet_journey_data.dart';
import 'package:poetry_quest/data/emei_general.dart';
import 'package:poetry_quest/data/emei_hard.dart';
import 'package:poetry_quest/models/game_level.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/widgets/custom_app_bar.dart';
import 'package:poetry_quest/widgets/layer_widgets/story_intro_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/choice_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/poem_card_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/map_timeline_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/hard_sensory_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/hard_context_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/hard_wrong_int_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/hard_empathy_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/hard_reveal_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/medium_sensory_click_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/general_context_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/general_empathy_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/general_reveal_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/poem_full_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/poem_drag_fill_layer.dart';
import 'package:poetry_quest/widgets/layer_widgets/meaning_match_layer.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class JourneyScreen extends StatefulWidget {
  final int levelIndex;
  final String difficulty;

  const JourneyScreen({
    Key? key,
    required this.levelIndex,
    required this.difficulty,
  }) : super(key: key);

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;
  late GameLevel _currentGameLevel;
  bool _isCompleted = false;
  bool _showIntro = true;

  // 背景音乐播放器
  late AudioPlayer _bgmPlayer;
  bool _isMuted = false;

  static const int _gameLayersCount = 5;

  @override
  void initState() {
    super.initState();
    _bgmPlayer = AudioPlayer();
    _loadLevel();
    // 困难或中等难度时播放对应背景音乐
    if (widget.difficulty == '困难') {
      _playHardBackgroundMusic();
    } else if (widget.difficulty == '中等') {
      _playMediumBackgroundMusic();
    }
  }

  void _loadLevel() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final poem = provider.selectedPoem;

    if (poem != null && poem.title == '峨眉山月歌') {
      switch (widget.difficulty) {
        case '简单':
          _currentGameLevel = xinglunanLevel;
          break;
        case '中等':
          _currentGameLevel = emeiGeneralLevel;
          break;
        case '困难':
          _currentGameLevel = emeiHardLevel;
          break;
        default:
          _currentGameLevel = xinglunanLevel;
      }
    } else {
      _currentGameLevel = xinglunanLevel;
    }

    provider.resetLayers();
    _pageController = PageController(initialPage: 0);
    _currentPageNotifier = ValueNotifier<int>(0);
    _showIntro = (widget.difficulty == '简单');
  }

  void _playHardBackgroundMusic() async {
    try {
      await _bgmPlayer.play(AssetSource('audio/hard_bgm.mp3'));
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('播放困难背景音乐失败: $e');
    }
  }

  void _playMediumBackgroundMusic() async {
    try {
      await _bgmPlayer.play(AssetSource('audio/medium_journey_bgm.mp3'));
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('播放中等背景音乐失败: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _bgmPlayer.pause();
      } else {
        _bgmPlayer.resume();
      }
    });
  }

  void _stopBackgroundMusic() {
    _bgmPlayer.stop();
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _onIntroComplete() {
    setState(() => _showIntro = false);
  }

  void _goToNextLayer() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final currentIndex = _currentPageNotifier.value;
    if (currentIndex < _gameLayersCount - 1) {
      provider.nextLayer();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  Widget _buildGameLayer(int index) {
    final layer = _currentGameLevel.layers[index];
    final difficulty = _currentGameLevel.difficulty;

    // ========== 简单难度 ==========
    if (difficulty == '简单') {
      switch (index) {
        case 0:
          return PoemFullLayer(
            poemTitle: _currentGameLevel.poemTitle,
            poemLines: _currentGameLevel.layers.last.poemLines ?? '''
峨眉山月半轮秋，影入平羌江水流。
夜发清溪向三峡，思君不见下渝州。''',
            onNext: _goToNextLayer,
          );
        case 1:
          return PoemDragFillLayer(onNext: _goToNextLayer);
        case 2:
          return MeaningMatchLayer(onNext: _goToNextLayer);
        case 3:
          return ChoiceLayer(
            onNext: _goToNextLayer,
            layerData: layer,
            difficulty: difficulty,
          );
        case 4:
          return PoemCardLayer(
            poemTitle: _currentGameLevel.poemTitle,
            poemLines: layer.poemLines ?? '''
峨眉山月半轮秋，影入平羌江水流。
夜发清溪向三峡，思君不见下渝州。''',
            summary: layer.fullInterpretation ?? '这是李白24岁离开家乡时写的，月亮代表他的思念。',
            difficulty: difficulty,
            onNext: _goToNextLayer,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    // ========== 中等难度 ==========
    if (difficulty == '中等') {
      switch (index) {
        case 0:
          return MediumSensoryClickLayer(onNext: _goToNextLayer);
        case 1:
          return GeneralContextLayer(onNext: _goToNextLayer);
        case 2:
          return MapTimelineLayer(onNext: _goToNextLayer);
        case 3:
          return GeneralEmpathyLayer(onNext: _goToNextLayer);
        case 4:
          return GeneralRevealLayer(
            poemTitle: _currentGameLevel.poemTitle,
            poemLines: layer.poemLines ?? '''
峨眉山月半轮秋，影入平羌江水流。
夜发清溪向三峡，思君不见下渝州。''',
            summary: layer.fullInterpretation ?? '这是李白24岁离开家乡时写的，月亮代表他的思念。',
            onNext: _goToNextLayer,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    // ========== 困难难度 ==========
    if (difficulty == '困难') {
      switch (index) {
        case 0:
          return HardSensoryLayer(onNext: _goToNextLayer);
        case 1:
          return HardContextLayer(onNext: _goToNextLayer);
        case 2:
          return HardWrongIntLayer(onNext: _goToNextLayer);
        case 3:
          return HardEmpathyLayer(onNext: _goToNextLayer);
        case 4:
          return HardRevealLayer(
            poemTitle: _currentGameLevel.poemTitle,
            poemLines: layer.poemLines ?? '''
峨眉山月半轮秋，影入平羌江水流。
夜发清溪向三峡，思君不见下渝州。''',
            summary: layer.fullInterpretation ?? '这是李白24岁离开家乡时写的，月亮代表他的思念。',
            onNext: _goToNextLayer,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return const SizedBox.shrink();
  }

  Future<void> _completeLevelAndReturn() async {
    if (_isCompleted) return;
    _isCompleted = true;
    _stopBackgroundMusic();
    final provider = Provider.of<GameProvider>(context, listen: false);
    await provider.completeCurrentLevel(difficulty: widget.difficulty);
    if (mounted) Navigator.of(context).pop();
  }

  void _showCompletionDialog() {
    int scoreReward = 0;
    switch (widget.difficulty) {
      case '简单':
        scoreReward = 10;
        break;
      case '中等':
        scoreReward = 20;
        break;
      case '困难':
        scoreReward = 30;
        break;
      default:
        scoreReward = 10;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: AppTheme.accentColor, size: 28),
            const SizedBox(width: 8),
            const Text('🎉 闯关成功'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('你完成了《${_currentGameLevel.poemTitle}》的学习！'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightInkColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '大鹏阶段：${_currentGameLevel.dapanStage}',
                    style: TextStyle(color: AppTheme.inkColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '人生阶段：${_currentGameLevel.lifeStage}',
                    style: TextStyle(color: AppTheme.inkColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '情感主题：${_currentGameLevel.emotionTheme}',
                    style: TextStyle(color: AppTheme.inkColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppTheme.accentColor, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '获得积分奖励',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '+$scoreReward 分',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('继续加油，下一关更精彩！'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 100), _completeLevelAndReturn);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = _currentPageNotifier.value;

    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.difficulty}·第${widget.levelIndex + 1}关 · ${_currentGameLevel.poemTitle}',
        actions: (widget.difficulty == '困难' || widget.difficulty == '中等')
            ? [
                IconButton(
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: _toggleMute,
                  tooltip: _isMuted ? '取消静音' : '静音',
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.paperColor,
                  AppTheme.lightInkColor.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.inkColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flutter_dash, color: AppTheme.accentColor, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentGameLevel.dapanStage,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.inkColor,
                              ),
                            ),
                            Text(
                              _currentGameLevel.lifeStage,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.lightInkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentGameLevel.emotionTheme,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CirclePageIndicator(
                    itemCount: _gameLayersCount,
                    currentPageNotifier: _currentPageNotifier,
                    dotColor: AppTheme.lightInkColor.withValues(alpha: 0.3),
                    selectedDotColor: AppTheme.accentColor,
                    size: 8.0,
                    selectedSize: 12.0,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _gameLayersCount,
                    onPageChanged: (index) {
                      _currentPageNotifier.value = index;
                      Provider.of<GameProvider>(context, listen: false).nextLayer();
                    },
                    itemBuilder: (context, index) => _buildGameLayer(index),
                  ),
                ),
              ],
            ),
          ),
          if (_showIntro)
            StoryIntroLayer(
              onComplete: _onIntroComplete,
              poetName: _currentGameLevel.poetName,
              poemTitle: _currentGameLevel.poemTitle,
            ),
        ],
      ),
    );
  }
}