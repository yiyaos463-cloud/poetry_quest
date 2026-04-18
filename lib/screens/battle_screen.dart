import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:audioplayers/audioplayers.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({Key? key}) : super(key: key);

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> with WidgetsBindingObserver {
  late List<Map<String, dynamic>> _selectedQuestions;
  int _score = 0;
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _isMuted = false;

  final List<Map<String, dynamic>> _fullQuestionBank = [
    {'question': '“床前明月光，疑是地上霜”的作者是谁？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 0, 'explanation': '李白的《静夜思》'},
    {'question': '“飞流直下三千尺，疑是银河落九天”描写的是哪里的瀑布？', 'options': ['庐山', '黄山', '泰山', '华山'], 'answer': 0, 'explanation': '李白《望庐山瀑布》'},
    {'question': '“朱门酒肉臭，路有冻死骨”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 1, 'explanation': '杜甫《自京赴奉先县咏怀五百字》'},
    {'question': '“但愿人长久，千里共婵娟”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 2, 'explanation': '苏轼《水调歌头》'},
    {'question': '“寻寻觅觅，冷冷清清，凄凄惨惨戚戚”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 3, 'explanation': '李清照《声声慢》'},
    {'question': '“天生我材必有用，千金散尽还复来”出自哪首诗？', 'options': ['《将进酒》', '《行路难》', '《静夜思》', '《望庐山瀑布》'], 'answer': 0, 'explanation': '李白《将进酒》'},
    {'question': '“安能摧眉折腰事权贵，使我不得开心颜”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 0, 'explanation': '李白《梦游天姥吟留别》'},
    {'question': '“国破山河在，城春草木深”出自哪首诗？', 'options': ['《春望》', '《石壕吏》', '《登高》', '《茅屋为秋风所破歌》'], 'answer': 0, 'explanation': '杜甫《春望》'},
    {'question': '“竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 2, 'explanation': '苏轼《定风波》'},
    {'question': '“常记溪亭日暮，沉醉不知归路”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 3, 'explanation': '李清照《如梦令》'},
    {'question': '“举头望明月，低头思故乡”出自哪首诗？', 'options': ['《静夜思》', '《峨眉山月歌》', '《月下独酌》', '《关山月》'], 'answer': 0, 'explanation': '李白《静夜思》'},
    {'question': '“无边落木萧萧下，不尽长江滚滚来”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 1, 'explanation': '杜甫《登高》'},
    {'question': '“欲把西湖比西子，淡妆浓抹总相宜”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 2, 'explanation': '苏轼《饮湖上初晴后雨》'},
    {'question': '“生当作人杰，死亦为鬼雄”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 3, 'explanation': '李清照《夏日绝句》'},
    {'question': '“长风破浪会有时，直挂云帆济沧海”出自哪首诗？', 'options': ['《行路难》', '《将进酒》', '《蜀道难》', '《早发白帝城》'], 'answer': 0, 'explanation': '李白《行路难》'},
    {'question': '“感时花溅泪，恨别鸟惊心”出自哪首诗？', 'options': ['《春望》', '《登高》', '《石壕吏》', '《兵车行》'], 'answer': 0, 'explanation': '杜甫《春望》'},
    {'question': '“不识庐山真面目，只缘身在此山中”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 2, 'explanation': '苏轼《题西林壁》'},
    {'question': '“争渡，争渡，惊起一滩鸥鹭”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 3, 'explanation': '李清照《如梦令》'},
    {'question': '“孤帆远影碧空尽，唯见长江天际流”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 0, 'explanation': '李白《黄鹤楼送孟浩然之广陵》'},
    {'question': '“会当凌绝顶，一览众山小”是哪位诗人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 1, 'explanation': '杜甫《望岳》'},
    {'question': '“大江东去，浪淘尽，千古风流人物”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 2, 'explanation': '苏轼《念奴娇·赤壁怀古》'},
    {'question': '“此情无计可消除，才下眉头，却上心头”是哪位词人的作品？', 'options': ['李白', '杜甫', '苏轼', '李清照'], 'answer': 3, 'explanation': '李清照《一剪梅》'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectRandomQuestions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sfxPlayer.dispose();
    _bgmPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _bgmPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      if (provider.appTabIndex == 2 && !_isMuted) {
        _bgmPlayer.resume();
      }
    }
  }

  void _playBackgroundMusicIfNeeded() async {
    try {
      if (_bgmPlayer.state != PlayerState.playing) {
        await _bgmPlayer.play(AssetSource('audio/battle_bgm.mp3'));
        await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      }
    } catch (e) {
      print('播放挑战背景音乐失败: $e');
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

  void _selectRandomQuestions() {
    final random = Random();
    final shuffled = List<Map<String, dynamic>>.from(_fullQuestionBank)..shuffle(random);
    _selectedQuestions = shuffled.take(10).toList();
  }

  void _restart() {
    setState(() {
      _selectRandomQuestions();
      _score = 0;
      _currentQuestionIndex = 0;
      _isAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    
    // 根据当前标签页控制音乐播放/暂停
    if (provider.appTabIndex != 2) {
      _bgmPlayer.pause();
    } else {
      if (!_isMuted) {
        _playBackgroundMusicIfNeeded();
      }
    }

    if (_selectedQuestions.isEmpty) return const Center(child: CircularProgressIndicator());
    final currentQuestion = _selectedQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('挑战'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: _toggleMute,
            tooltip: _isMuted ? '取消静音' : '静音',
          ),
        ],
        backgroundColor: AppTheme.paperColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.inkColor),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.inkColor,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.paperColor,
              const Color(0xFF7E57C2).withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('挑战', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.inkColor)),
                        Text('随机10题，每题1分', style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Text('$_score 分', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text('第 ${_currentQuestionIndex + 1} 题', style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) / _selectedQuestions.length,
                          backgroundColor: AppTheme.lightInkColor.withValues(alpha: 0.2),
                          color: const Color(0xFF7E57C2),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${_currentQuestionIndex + 1}/${_selectedQuestions.length}',
                        style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor)),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppTheme.inkColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Text(
                    currentQuestion['question'] as String,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.inkColor, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: (currentQuestion['options'] as List).length,
                    itemBuilder: (context, index) {
                      final option = (currentQuestion['options'] as List)[index];
                      final isWrong = _isAnswered && !_isCorrect && index == currentQuestion['answer'];
                      return GestureDetector(
                        onTap: () { if (!_isAnswered) _checkAnswer(index); },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isAnswered
                                ? (index == currentQuestion['answer']
                                    ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                                    : (isWrong ? const Color(0xFFF44336).withValues(alpha: 0.1) : Colors.white))
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isAnswered
                                  ? (index == currentQuestion['answer']
                                      ? const Color(0xFF4CAF50)
                                      : (isWrong ? const Color(0xFFF44336) : AppTheme.lightInkColor.withValues(alpha: 0.3)))
                                  : AppTheme.lightInkColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: _getOptionColor(index), shape: BoxShape.circle),
                                child: Center(
                                  child: Text(String.fromCharCode(65 + index),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(option, style: TextStyle(fontSize: 16, color: AppTheme.inkColor))),
                              if (_isAnswered && index == currentQuestion['answer'])
                                const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isAnswered)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppTheme.inkColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
                    ),
                    child: Column(
                      children: [
                        Text(_isCorrect ? '回答正确！' : '回答错误',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336))),
                        const SizedBox(height: 8),
                        Text(currentQuestion['explanation'] as String,
                            style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor, height: 1.5), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7E57C2), padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: const Text('下一题', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getOptionColor(int index) {
    const colors = [Color(0xFF5C6BC0), Color(0xFF8D6E63), Color(0xFF26A69A), Color(0xFFEC407A)];
    return colors[index % colors.length];
  }

  void _checkAnswer(int selectedIndex) {
    final currentQuestion = _selectedQuestions[_currentQuestionIndex];
    final isCorrect = selectedIndex == currentQuestion['answer'];
    
    if (isCorrect) {
      _sfxPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      _sfxPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
    
    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _score += 1;
        Provider.of<GameProvider>(context, listen: false).addScore(1);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      if (_currentQuestionIndex < _selectedQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('挑战完成'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 60, color: AppTheme.accentColor),
            const SizedBox(height: 16),
            Text('恭喜你完成了所有题目！', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.inkColor)),
            const SizedBox(height: 8),
            Text('得分: $_score/${_selectedQuestions.length}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
            const SizedBox(height: 16),
            Text(
              _score >= 8 ? '太棒了！诗词功底深厚！' : _score >= 6 ? '不错！继续加油！' : '再接再厉，多读诗词！',
              style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<GameProvider>(context, listen: false).setAppTab(0);
            },
            child: const Text('回首页'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _restart();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
            child: const Text('再挑战一次'),
          ),
        ],
      ),
    );
  }
}