import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:poetry_quest/utils/theme.dart';

class CharacterParticleLayer extends StatefulWidget {
  final VoidCallback onNext;

  const CharacterParticleLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<CharacterParticleLayer> createState() => _CharacterParticleLayerState();
}

class _CharacterParticleLayerState extends State<CharacterParticleLayer>
    with SingleTickerProviderStateMixin {
  // 三个目标：明月、故乡、亲友
  final List<Map<String, dynamic>> _targets = [
    {
      'id': 'moon',
      'label': '🌙 明月',
      'color': Colors.yellow.shade300,
      'poem': '举头望明月，低头思故乡。',
      'explanation': '月亮是李白诗歌中最常见的意象，象征永恒与思念。',
    },
    {
      'id': 'hometown',
      'label': '🏔️ 故乡',
      'color': Colors.green.shade300,
      'poem': '仍怜故乡水，万里送行舟。',
      'explanation': '故乡是李白永远回不去的地方，也是他诗歌的源泉。',
    },
    {
      'id': 'friends',
      'label': '👥 亲友',
      'color': Colors.blue.shade300,
      'poem': '思君不见下渝州。',
      'explanation': '“君”既是月亮，也是故乡，也是远方的亲友。',
    },
  ];

  // 当前拖拽的“君”字位置
  Offset _dragPosition = const Offset(0, 0);
  bool _isDragging = false;
  String? _currentTargetId;
  bool _showParticles = false;
  List<Particle> _particles = [];
  late AnimationController _particleController;

  // 已解锁的目标
  final Set<String> _unlockedTargets = {};

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragPosition = details.localPosition;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = Offset(
        _dragPosition.dx + details.delta.dx,
        _dragPosition.dy + details.delta.dy,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      
      // 检查是否拖到目标上
      for (final target in _targets) {
        final targetCenter = _getTargetCenter(target['id'] as String);
        final distance = (_dragPosition - targetCenter).distance;
        
        if (distance < 60) { // 目标半径
          _onTargetHit(target['id'] as String);
          return;
        }
      }
      
      // 没有命中目标，回到原位
      _dragPosition = const Offset(0, 0);
    });
  }

  Offset _getTargetCenter(String targetId) {
    switch (targetId) {
      case 'moon':
        return const Offset(-120, 100);
      case 'hometown':
        return const Offset(0, -120);
      case 'friends':
        return const Offset(120, 100);
      default:
        return const Offset(0, 0);
    }
  }

  void _onTargetHit(String targetId) {
    if (_unlockedTargets.contains(targetId)) return;
    
    setState(() {
      _currentTargetId = targetId;
      _unlockedTargets.add(targetId);
      _showParticles = true;
      _createParticles();
    });
    
    _particleController.forward(from: 0.0);
    
    // 显示解释对话框
    final target = _targets.firstWhere((t) => t['id'] == targetId);
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(target['label'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                target['poem'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12),
              Text(target['explanation'] as String),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('明白了'),
            ),
          ],
        ),
      );
    });
    
    // 检查是否全部解锁
    if (_unlockedTargets.length == 3) {
      Future.delayed(const Duration(seconds: 2), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('🎉 虚实结合，多重象征'),
            content: const Text(
              '“君”既是月亮，也是故乡，也是亲友。\n'
              '李白用虚实结合的手法，让一个“君”字承载了多重情感。',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNext();
                },
                child: const Text('继续'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _createParticles() {
    _particles.clear();
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        position: _dragPosition,
        velocity: Offset(
          (random.nextDouble() - 0.5) * 4,
          (random.nextDouble() - 0.5) * 4,
        ),
        color: _targets
            .firstWhere((t) => t['id'] == _currentTargetId)['color'] as Color,
        size: random.nextDouble() * 4 + 2,
        life: 1.0,
      ));
    }
  }

  void _updateParticles() {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final particle = _particles[i];
      particle.position += particle.velocity;
      particle.life -= 0.02;
      
      if (particle.life <= 0) {
        _particles.removeAt(i);
      }
    }
    
    if (_particles.isEmpty) {
      _showParticles = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A0E2A),
            const Color(0xFF1A1F3A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 星空背景
          Positioned.fill(
            child: CustomPaint(
              painter: _StarPainter(),
            ),
          ),
          // 江水倒影（毛玻璃效果）
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: ClipRect(
              child: BackdropFilter(
                filter: const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.srcOver,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade900.withOpacity(0.3),
                        Colors.blue.shade800.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 李白剪影
          Positioned(
            bottom: 100,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Container(
              width: 100,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          // 主内容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🖋️ 拖拽“君”字，探索多重象征',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“思君不见”的“君”究竟是谁？\n将“君”字拖到不同的意象上，看看会发生什么。',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  // 三个目标
                  Expanded(
                    child: Stack(
                      children: [
                        // 目标：明月
                        _buildTarget('moon', const Offset(-120, 100)),
                        // 目标：故乡
                        _buildTarget('hometown', const Offset(0, -120)),
                        // 目标：亲友
                        _buildTarget('friends', const Offset(120, 100)),
                        // 可拖拽的“君”字
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2 + _dragPosition.dx - 40,
                          top: MediaQuery.of(context).size.height / 2 + _dragPosition.dy - 40,
                          child: GestureDetector(
                            onPanStart: _onDragStart,
                            onPanUpdate: _onDragUpdate,
                            onPanEnd: _onDragEnd,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _isDragging
                                    ? Colors.yellow.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.yellow,
                                  width: 3,
                                ),
                                boxShadow: _isDragging
                                    ? [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.5),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '君',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 粒子效果
                        if (_showParticles)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _ParticlePainter(particles: _particles),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 进度指示
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _targets.map((target) {
                        final isUnlocked = _unlockedTargets.contains(target['id']);
                        return Column(
                          children: [
                            Icon(
                              isUnlocked ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isUnlocked ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              target['label'] as String,
                              style: TextStyle(
                                color: isUnlocked ? Colors.white : Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarget(String targetId, Offset offset) {
    final target = _targets.firstWhere((t) => t['id'] == targetId);
    final isUnlocked = _unlockedTargets.contains(targetId);
    
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + offset.dx - 60,
      top: MediaQuery.of(context).size.height / 2 + offset.dy - 60,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: (target['color'] as Color).withOpacity(isUnlocked ? 0.3 : 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isUnlocked
                ? target['color'] as Color
                : Colors.grey.withOpacity(0.5),
            width: isUnlocked ? 3 : 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: (target['color'] as Color).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                target['label'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
              ),
              if (isUnlocked)
                const SizedBox(height: 4),
              if (isUnlocked)
                const Icon(Icons.check, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// 粒子类
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
}

// 粒子绘制器
class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        particle.position,
        particle.size * particle.life,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return true;
  }
}

// 星空绘制器
class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..color = Colors.white;
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      final opacity = random.nextDouble() * 0.8 + 0.2;
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => false;
}