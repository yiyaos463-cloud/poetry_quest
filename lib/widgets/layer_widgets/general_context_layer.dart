import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:audioplayers/audioplayers.dart';

class GeneralContextLayer extends StatefulWidget {
  final VoidCallback onNext;
  const GeneralContextLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<GeneralContextLayer> createState() => _GeneralContextLayerState();
}

class _GeneralContextLayerState extends State<GeneralContextLayer> {
  int _selectedOption = -1;
  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _isMuted = false;

  final List<Map<String, String>> _dialogues = [
    {
      'question': '这一走，故乡的月色便只能在诗里见了？',
      'answer': '蜀江水碧蜀山青，若非心向沧海，谁愿轻离故土。月是故乡明，亦照远行人。'
    },
    {
      'question': '三峡险滩在前，可曾想过回头？',
      'answer': '大鹏一日同风起，扶摇直上九万里。既已出蜀，何惧风浪？'
    },
    {
      'question': '若这一生再不得归乡，可会后悔？',
      'answer': '此心安处是吾乡。我把故乡的月色装进诗里，走到哪里，便带到哪里。'
    },
  ];

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    try {
      await _bgmPlayer.play(AssetSource('audio/medium_context_bgm.mp3'));
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('播放对话页背景音乐失败: $e');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/layer_panorama.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              // 诗人形象区域
              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/libai.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '李白 · 心声',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '轻触疑问，聆听诗仙的回答',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _dialogues.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedOption == index;
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B8C6F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _dialogues[index]['question']!,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isSelected)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E2C1E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _dialogues[index]['answer']!,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () => setState(() => _selectedOption = index),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black.withValues(alpha: 0.5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                            child: const Text('揭晓答案'),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _selectedOption >= 0 ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  ),
                  child: const Text('继续前行'),
                ),
              ),
            ],
          ),
          // 静音按钮
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
              onPressed: _toggleMute,
            ),
          ),
        ],
      ),
    );
  }
}