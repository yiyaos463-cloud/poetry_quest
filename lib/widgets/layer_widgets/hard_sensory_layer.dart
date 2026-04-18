import 'package:flutter/material.dart';

class HardSensoryLayer extends StatefulWidget {
  final VoidCallback onNext;
  const HardSensoryLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<HardSensoryLayer> createState() => _HardSensoryLayerState();
}

class _HardSensoryLayerState extends State<HardSensoryLayer> {
  String _currentMood = '清冷';
  bool _hasSelected = false;

  void _setMood(String mood) {
    setState(() {
      _currentMood = mood;
      _hasSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = _currentMood == '清冷'
        ? 'assets/images/emei/mood_qingleng.png'
        : 'assets/images/emei/mood_kaikuo.png';

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // 半透明遮罩层，让文字更清晰
          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),
          // 意境说明卡片
          if (_hasSelected)
            Positioned(
              top: 80,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Text(
                  _currentMood == '清冷'
                      ? '清冷并非凄凉。李白主动出发，月色清冷，江水悠悠，带着一丝孤独，却无恐惧。'
                      : '开阔方显壮阔。船行江上，天地宽广，李白心怀远方，前路虽远，意气风发。',
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // 底部操作区域
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 清冷按钮
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setMood('清冷'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentMood == '清冷'
                                ? Colors.indigo.shade400
                                : Colors.indigo.shade300.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('清冷', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // 开阔按钮
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setMood('开阔'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentMood == '开阔'
                                ? Colors.amber.shade400
                                : Colors.amber.shade300.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('开阔', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 继续按钮（始终可见）
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('继续前行', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}