import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:audioplayers/audioplayers.dart';

class GeneralEmpathyLayer extends StatefulWidget {
  final VoidCallback onNext;
  const GeneralEmpathyLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<GeneralEmpathyLayer> createState() => _GeneralEmpathyLayerState();
}

class _GeneralEmpathyLayerState extends State<GeneralEmpathyLayer>
    with SingleTickerProviderStateMixin {
  bool _chosen = false;
  bool _lookBack = false;
  late AnimationController _boatController;
  late Animation<Offset> _boatPosition;
  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _boatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _boatController.dispose();
    _bgmPlayer.dispose();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    try {
      await _bgmPlayer.play(AssetSource('audio/medium_empathy_bgm.mp3'));
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('播放风骨抉择页背景音乐失败: $e');
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

  void _makeChoice(bool lookBack) {
    setState(() {
      _chosen = true;
      _lookBack = lookBack;
    });
    if (lookBack) {
      _boatPosition = Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: const Offset(-0.2, 0),
      ).animate(_boatController);
    } else {
      _boatPosition = Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: const Offset(0.7, 0),
      ).animate(_boatController);
    }
    _boatController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/layer_panorama.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (_chosen)
            AnimatedBuilder(
              animation: _boatController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(
                      _boatPosition.value.dx * MediaQuery.of(context).size.width,
                      0,
                    ),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _lookBack ? Icons.arrow_back : Icons.arrow_forward,
                      color: Colors.brown,
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _lookBack ? '回望故乡' : '顺江东下',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          if (!_chosen)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '船行至清溪，即将进入三峡。',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ChoiceCard(
                        title: '回望故乡',
                        color: const Color(0xFFB87B4A),
                        onTap: () => _makeChoice(true),
                      ),
                      const SizedBox(width: 24),
                      _ChoiceCard(
                        title: '顺江东下',
                        color: const Color(0xFF5B8C6F),
                        onTap: () => _makeChoice(false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (_chosen)
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _lookBack
                          ? '船速渐缓，峨眉山月定格在身后。李白低声道：“故乡啊……”'
                          : '小船破浪而出，江面豁然开朗。李白迎风而立：“前路漫漫，唯此心不改。”',
                      style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _lookBack
                          ? '—— 他选择了回望，却把眷恋化作了诗行。'
                          : '—— 他选择了前行，用一生去丈量远方。',
                      style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: widget.onNext,
                      child: const Text('继续前行'),
                    ),
                  ],
                ),
              ),
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

class _ChoiceCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}