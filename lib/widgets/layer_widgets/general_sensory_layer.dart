import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class GeneralSensoryLayer extends StatefulWidget {
  final VoidCallback onNext;
  const GeneralSensoryLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<GeneralSensoryLayer> createState() => _GeneralSensoryLayerState();
}

class _GeneralSensoryLayerState extends State<GeneralSensoryLayer> {
  final Map<String, bool> _matched = {
    'moon': false,
    'water': false,
    'wind': false,
  };

  final List<Map<String, String>> _cards = [
    {'id': 'moon', 'label': '🌙 半轮秋月'},
    {'id': 'water', 'label': '💧 江水映月'},
    {'id': 'wind', 'label': '🌬️ 微凉江风'},
  ];

  bool _dialogShown = false;

  bool get _allMatched => _matched.values.every((v) => v);

  void _onAccept(String id) {
    setState(() {
      _matched[id] = true;
    });
    // 全部匹配后，如果没有弹过窗，则弹出成功提示
    if (_allMatched && !_dialogShown) {
      _dialogShown = true;
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ 意象匹配完成'),
        content: const Text(
          '你成功将意象与诗句对应！\n半轮秋月、江水映月、微凉江风，共同营造出清冷的秋江夜景。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onNext(); // 关闭对话框后进入下一层
            },
            child: const Text('继续'),
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
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
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
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 12,
                    children: [
                      const Text('峨眉山月', style: TextStyle(fontSize: 18)),
                      _buildDropTarget('moon', '半轮秋月'),
                      const Text('，影入平羌', style: TextStyle(fontSize: 18)),
                      _buildDropTarget('water', '江水映月'),
                      const Text('。\n夜发清溪向三峡，思君不见下渝州。',
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // 未匹配的卡片才显示
          if (!_allMatched)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _cards.map((card) {
                final id = card['id']!;
                if (_matched[id]!) return const SizedBox.shrink();
                return Draggable<String>(
                  data: id,
                  feedback: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        card['label']!,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      card['label']!,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppTheme.lightInkColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(card['label']!, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            ),
          const Spacer(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDropTarget(String id, String label) {
    final isFilled = _matched[id]!;
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isFilled
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isFilled
                  ? Colors.green
                  : (candidateData.isNotEmpty
                      ? AppTheme.accentColor
                      : Colors.grey.shade400),
              width: 2,
            ),
          ),
          child: Text(
            isFilled ? label : '______',
            style: TextStyle(
              fontSize: 18,
              color: isFilled ? Colors.green.shade800 : Colors.grey.shade700,
              fontWeight: isFilled ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) {
        if (details.data == id) {
          _onAccept(id);
        }
      },
    );
  }
}