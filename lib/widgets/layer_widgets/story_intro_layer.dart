import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class StoryIntroLayer extends StatefulWidget {
  final VoidCallback onComplete;
  final String poetName;
  final String poemTitle;

  const StoryIntroLayer({
    Key? key,
    required this.onComplete,
    required this.poetName,
    required this.poemTitle,
  }) : super(key: key);

  @override
  State<StoryIntroLayer> createState() => _StoryIntroLayerState();
}

class _StoryIntroLayerState extends State<StoryIntroLayer>
    with SingleTickerProviderStateMixin {
  // ========== 可调整参数 ==========
  static const double _boatBobAmplitude = 14.0;      // 李白上下浮动幅度
  static const double _boatScaleStart = 1.0;         // 李白起始大小
  static const double _boatScaleEnd = 0.55;          // 李白终点大小（近大远小）
  static const double _willowScale = 0.5;            // 枝条缩小为原来的一半
  static const double _willowBobAmplitude = 8.0;     // 枝条上下浮动幅度
  static const double _willowSwayAmplitude = 0.08;   // 枝条左右摆动幅度（加大）
  // =============================

  late AnimationController _masterController;
  
  // 李白动画
  late Animation<double> _boatFadeIn;
  late Animation<double> _boatFadeOut;
  late Animation<double> _boatBob;
  late Animation<Offset> _boatDrift;    // 从左下到右上的飘移
  late Animation<double> _boatScale;    // 近大远小

  // 枝条动画
  late Animation<double> _willowSway;   // 左右摆动
  late Animation<double> _willowFade;
  late Animation<double> _willowBob;    // 上下浮动

  final List<Petal> _petals = [];
  final Random _random = Random();

  final List<String> _narrationLines = [
    '开元十二年，秋。',
    '二十四岁的李白，',
    '第一次离开生活了二十多年的蜀地。',
    '仗剑去国，辞亲远游。',
    '从峨眉山出发，经平羌江，过清溪，',
    '入三峡，奔渝州而去。',
    '船走了一夜，',
    '月亮一直跟着他...',
  ];
  int _currentLineIndex = 0;
  String _displayedText = '';

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initParticles();
    _startNarration();
  }

  void _initAnimations() {
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: false);

    // 李白淡入 (0 ~ 10%)
    _boatFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.1, curve: Curves.easeIn),
      ),
    );
    // 李白淡出 (70% ~ 100%)
    _boatFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // 上下浮动 (全程)
    _boatBob = Tween<double>(begin: -_boatBobAmplitude, end: _boatBobAmplitude).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // 飘移路径：从左下(-0.25, 0.15) 到 右上(0.3, -0.2)
    _boatDrift = Tween<Offset>(
      begin: const Offset(-0.25, 0.15),
      end: const Offset(0.3, -0.2),
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // 近大远小缩放
    _boatScale = Tween<double>(begin: _boatScaleStart, end: _boatScaleEnd).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // 枝条左右摆动（加大幅度）
    _willowSway = Tween<double>(begin: -_willowSwayAmplitude, end: _willowSwayAmplitude).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // 枝条上下浮动
    _willowBob = Tween<double>(begin: -_willowBobAmplitude, end: _willowBobAmplitude).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // 枝条淡出
    _willowFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _initParticles() {
    for (int i = 0; i < 10; i++) {
      _petals.add(Petal.random(_random));
    }
    Future.delayed(const Duration(seconds: 3), _addNewPetal);
  }

  void _addNewPetal() {
    if (!mounted) return;
    setState(() {
      _petals.add(Petal.random(_random));
      if (_petals.length > 20) {
        _petals.removeRange(0, _petals.length - 20);
      }
    });
    Future.delayed(const Duration(seconds: 2), _addNewPetal);
  }

  void _startNarration() {
    _showNextLine();
  }

  void _showNextLine() {
    if (_currentLineIndex < _narrationLines.length) {
      final line = _narrationLines[_currentLineIndex];
      _typewriterEffect(line);
    }
  }

  void _typewriterEffect(String fullText) {
    _displayedText = '';
    int charIndex = 0;
    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(const Duration(milliseconds: 80));
      if (charIndex < fullText.length) {
        setState(() {
          _displayedText += fullText[charIndex];
        });
        charIndex++;
        return true;
      } else {
        _currentLineIndex++;
        await Future.delayed(const Duration(milliseconds: 800));
        _showNextLine();
        return false;
      }
    });
  }

  void _finishIntro() {
    if (_isCompleted) return;
    _isCompleted = true;
    _masterController.stop();
    _audioPlayer.stop();
    widget.onComplete();
  }

  @override
  void dispose() {
    _masterController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (_currentLineIndex >= _narrationLines.length) {
          _finishIntro();
        }
      },
      child: Container(
        color: const Color(0xFF0D1B2A),
        child: Stack(
          children: [
            // 1. 背景图片（静止）
            Positioned.fill(
              child: Image.asset(
                'assets/images/emei/layer_panorama_v2.png',
                fit: BoxFit.cover,
              ),
            ),
            
            // 2. 深蓝色滤镜
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1A2E4A).withValues(alpha: 0.25),
              ),
            ),
            
            // 3. 李白与船（飘移 + 浮动 + 淡入淡出 + 近大远小）
            AnimatedBuilder(
              animation: _masterController,
              builder: (context, child) {
                // 计算当前透明度
                double opacity = 1.0;
                if (_masterController.value < 0.1) {
                  opacity = _boatFadeIn.value;
                } else if (_masterController.value > 0.7) {
                  opacity = _boatFadeOut.value;
                }
                
                return Positioned(
                  left: size.width * (0.45 + _boatDrift.value.dx) - 80,
                  top: size.height * (0.55 + _boatDrift.value.dy) - 120,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, _boatBob.value),
                      child: Transform.scale(
                        scale: _boatScale.value,   // 近大远小
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/emei/layer_libai_boat_v2.png',
                fit: BoxFit.contain,
                height: 200,
              ),
            ),

            // 4. 柳枝（右上角，摆动 + 上下浮动 + 缩小）
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: Listenable.merge([_willowSway, _willowFade, _willowBob]),
                child: Transform.scale(
                  scale: _willowScale,
                  child: Image.asset(
                    'assets/images/emei/layer_willow_leaves.png',
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
                builder: (context, child) {
                  return Opacity(
                    opacity: _willowFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _willowBob.value),
                      child: Transform.rotate(
                        angle: _willowSway.value,
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 5. 花瓣粒子
            ..._petals.map((petal) => _PetalWidget(petal: petal)),

            // 6. 渐变蒙层
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                    stops: const [0.0, 0.15, 0.85, 1.0],
                  ),
                ),
              ),
            ),

            // 7. 旁白文字
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: _displayedText.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0E6).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3E2C1E).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _displayedText,
                    style: const TextStyle(
                      fontFamily: 'NotoSerifSC',
                      fontSize: 20,
                      height: 1.6,
                      color: Color(0xFF3E2C1E),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // 8. 点击继续提示
            if (_currentLineIndex >= _narrationLines.length)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E2C1E).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      '点击继续',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 花瓣粒子模型（保持不变）
class Petal {
  late double x;
  late double y;
  late double speed;
  late double size;
  late double rotation;
  late double opacity;

  Petal.random(Random random) {
    x = random.nextDouble();
    y = random.nextDouble() * -0.2;
    speed = 0.003 + random.nextDouble() * 0.008;
    size = 6 + random.nextDouble() * 10;
    rotation = random.nextDouble() * 2 * pi;
    opacity = 0.4 + random.nextDouble() * 0.4;
  }

  void update() {
    y += speed;
    if (y > 1.2) {
      y = -0.2;
      x = Random().nextDouble();
    }
    rotation += 0.01;
  }
}

class _PetalWidget extends StatefulWidget {
  final Petal petal;
  const _PetalWidget({required this.petal});

  @override
  State<_PetalWidget> createState() => _PetalWidgetState();
}

class _PetalWidgetState extends State<_PetalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _controller.addListener(() {
      setState(() {
        widget.petal.update();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      left: widget.petal.x * size.width,
      top: widget.petal.y * size.height,
      child: Transform.rotate(
        angle: widget.petal.rotation,
        child: Opacity(
          opacity: widget.petal.opacity,
          child: Container(
            width: widget.petal.size,
            height: widget.petal.size,
            decoration: BoxDecoration(
              color: const Color(0xFFE8A598).withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}