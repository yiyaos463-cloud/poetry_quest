import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class ImageryMatchLayer extends StatefulWidget {
  final VoidCallback onNext;

  const ImageryMatchLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<ImageryMatchLayer> createState() => _ImageryMatchLayerState();
}

class _ImageryMatchLayerState extends State<ImageryMatchLayer> {
  // 诗句列表（打乱顺序）
  final List<String> _lines = [
    '峨眉山月半轮秋',
    '影入平羌江水流',
    '夜发清溪向三峡',
    '思君不见下渝州',
  ]..shuffle();

  // 译文列表（固定顺序）
  final List<String> _meanings = [
    '峨眉山头，挂着半圆的秋月',
    '月影倒映在平羌江中，随波流淌',
    '夜里从清溪出发，驶向三峡',
    '想念你却见不到，船已奔向渝州',
  ];

  // 正确的配对映射（诗句 -> 译文索引）
  final Map<String, int> _correctMap = {
    '峨眉山月半轮秋': 0,
    '影入平羌江水流': 1,
    '夜发清溪向三峡': 2,
    '思君不见下渝州': 3,
  };

  // 当前配对状态：诗句 -> 是否已配对
  final Map<String, bool> _paired = {};

  // 拖拽中的诗句
  String? _draggingLine;

  @override
  void initState() {
    super.initState();
    for (var line in _lines) {
      _paired[line] = false;
    }
  }

  void _onAccept(String line, int meaningIndex) {
    if (_correctMap[line] == meaningIndex) {
      setState(() {
        _paired[line] = true;
      });
      // 检查是否全部完成
      if (_paired.values.every((p) => p)) {
        _showSuccessDialog();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('再想想，这句诗的意思是这个吗？'),
          backgroundColor: AppTheme.accentColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ 配对成功'),
        content: const Text('你已理解了每句诗的含义！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onNext();
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.paperColor,
            AppTheme.lightInkColor.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📜 将诗句与正确译文配对',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '拖拽左侧的诗句到右侧对应的译文上',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    // 左侧：诗句列表（可拖拽）
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('诗句', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._lines.map((line) => _buildDraggableLine(line)).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 右侧：译文列表（拖拽目标）
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('译文', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._meanings.asMap().entries.map((entry) {
                            return _buildDragTarget(entry.key, entry.value);
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableLine(String line) {
    final isPaired = _paired[line] ?? false;
    if (isPaired) {
      // 已配对的不显示，或显示为灰色不可拖拽
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            Expanded(child: Text(line, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      );
    }

    return Draggable<String>(
      data: line,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.paperColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.accentColor, width: 2),
          ),
          child: Text(line, style: const TextStyle(fontSize: 16)),
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(line, style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
      ),
      onDragStarted: () {
        setState(() {
          _draggingLine = line;
        });
      },
      onDragCompleted: () {
        setState(() {
          _draggingLine = null;
        });
      },
      onDraggableCanceled: (_, __) {
        setState(() {
          _draggingLine = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.lightInkColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(line, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildDragTarget(int index, String meaning) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        // 检查是否已有诗句配对到这个位置
        final pairedLine = _paired.entries.firstWhere(
          (e) => e.value && _correctMap[e.key] == index,
          orElse: () => const MapEntry('', false),
        ).key;

        if (pairedLine.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pairedLine, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(meaning, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 70),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? AppTheme.accentColor.withValues(alpha: 0.2)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: candidateData.isNotEmpty
                  ? AppTheme.accentColor
                  : AppTheme.lightInkColor.withValues(alpha: 0.3),
              width: candidateData.isNotEmpty ? 2 : 1,
            ),
          ),
          child: Text(meaning, style: const TextStyle(fontSize: 16)),
        );
      },
      onAcceptWithDetails: (details) {
        _onAccept(details.data, index);
      },
    );
  }
}