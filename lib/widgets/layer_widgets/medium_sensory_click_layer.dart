import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class MediumSensoryClickLayer extends StatefulWidget {
  final VoidCallback onNext;
  const MediumSensoryClickLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<MediumSensoryClickLayer> createState() => _MediumSensoryClickLayerState();
}

class _MediumSensoryClickLayerState extends State<MediumSensoryClickLayer> {
  final List<Map<String, String>> _cards = [
    {
      'title': '🌙 半轮秋月',
      'description': '月亮是故乡的象征。峨眉山月半轮秋，写出了秋夜山月的清冷之美，也暗示着诗人即将远离故乡。'
    },
    {
      'title': '💧 江水映月',
      'description': '月影倒映在平羌江中，随波流淌。诗人乘船远行，只有月影相伴，衬托出旅途的孤寂。'
    },
    {
      'title': '🌬️ 微凉江风',
      'description': '江风微凉，远处传来猿啼。感官上的清冷与听觉上的哀切，加深了离别的愁绪。'
    },
  ];

  final Set<int> _clickedIndices = {};

  bool get _allClicked => _clickedIndices.length == _cards.length;

  void _onCardTap(int index) {
    setState(() {
      _clickedIndices.add(index);
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_cards[index]['title']!),
        content: Text(_cards[index]['description']!),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/layer_panorama.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    '峨眉山月歌',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '点击下方意象卡片，了解它们的含义',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: _cards.asMap().entries.map((entry) {
                      final index = entry.key;
                      final card = entry.value;
                      final isClicked = _clickedIndices.contains(index);
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: isClicked ? Colors.green.withValues(alpha: 0.15) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isClicked ? Colors.green : AppTheme.lightInkColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card['title']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              if (isClicked) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_circle, color: Colors.green, size: 20),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (_allClicked)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('继续前行', style: TextStyle(fontSize: 18)),
              ),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}