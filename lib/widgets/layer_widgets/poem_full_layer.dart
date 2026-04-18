import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:poetry_quest/utils/theme.dart';

class PoemFullLayer extends StatefulWidget {
  final VoidCallback onNext;
  final String poemTitle;
  final String poemLines;

  const PoemFullLayer({
    Key? key,
    required this.onNext,
    required this.poemTitle,
    required this.poemLines,
  }) : super(key: key);

  @override
  State<PoemFullLayer> createState() => _PoemFullLayerState();
}

class _PoemFullLayerState extends State<PoemFullLayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _hasAutoPlayed = false;

  @override
  void initState() {
    super.initState();
    // 延迟一帧确保页面完全构建后再播放，避免与动画切换冲突
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playPoemAudio();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPoemAudio() async {
    if (_hasAutoPlayed) return;
    try {
      await _audioPlayer.play(AssetSource('audio/emei_poem.mp3'));
      setState(() {
        _isPlaying = true;
        _hasAutoPlayed = true;
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isPlaying = false);
      });
    } catch (e) {
      print('播放诗歌音频失败: $e');
    }
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.resume();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/layer_panorama_v2.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.darken),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white.withValues(alpha: 0.95),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '📜 ${widget.poemTitle}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                            iconSize: 32,
                            color: AppTheme.accentColor,
                            onPressed: _toggleAudio,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.poemLines,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 2.0,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Divider(color: AppTheme.lightInkColor.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Text(
                        '—— 李白《峨眉山月歌》',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _audioPlayer.stop();
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('继续前行'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}