import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class MeaningMatchLayer extends StatefulWidget {
  final VoidCallback onNext;
  const MeaningMatchLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<MeaningMatchLayer> createState() => _MeaningMatchLayerState();
}

class _MeaningMatchLayerState extends State<MeaningMatchLayer> {
  // 诗句顺序固定
  final List<String> _lines = [
    '峨眉山月半轮秋',
    '影入平羌江水流',
    '夜发清溪向三峡',
    '思君不见下渝州',
  ];

  // 原始译文（顺序正确）
  final List<String> _originalMeanings = [
    '峨眉山头，挂着半圆的秋月',
    '月影倒映在平羌江中，随波流淌',
    '夜里从清溪出发，驶向三峡',
    '想念你却见不到，船已奔向渝州',
  ];

  late List<MapEntry<int, String>> _shuffledMeanings; // 打乱后携带原始索引
  final Map<int, int> _matches = {}; // 诗句索引 -> 译文原始索引
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    // 打乱译文，但保留原始索引
    _shuffledMeanings = _originalMeanings.asMap().entries.toList()
      ..shuffle();
  }

  void _checkMatch(int lineIndex, int meaningOriginalIndex) {
    // 正确映射：第0句对索引0，第1句对索引1，以此类推
    if (lineIndex != meaningOriginalIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('配对错误，再试试'), duration: Duration(seconds: 1)),
      );
      return;
    }
    setState(() {
      _matches[lineIndex] = meaningOriginalIndex;
    });
    if (_matches.length == 4) {
      setState(() => _completed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.paperColor, AppTheme.lightInkColor.withValues(alpha: 0.15)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('🔗 将右侧译文拖到左侧诗句上', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧诗句（拖放目标）
                  Expanded(
                    child: Column(
                      children: _lines.asMap().entries.map((entry) {
                        final lineIndex = entry.key;
                        final line = entry.value;
                        final matchedOriginalIndex = _matches[lineIndex];
                        final isMatched = matchedOriginalIndex != null;
                        return DragTarget<int>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? Colors.green.shade50
                                    : (candidateData.isNotEmpty ? Colors.blue.shade50 : Colors.white),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isMatched
                                      ? Colors.green
                                      : (candidateData.isNotEmpty
                                          ? Colors.blue
                                          : AppTheme.lightInkColor.withValues(alpha: 0.3)),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(line, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  if (isMatched) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      _originalMeanings[matchedOriginalIndex],
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                          onAcceptWithDetails: (details) => _checkMatch(lineIndex, details.data),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 右侧译文（可拖拽）
                  Expanded(
                    child: Column(
                      children: _shuffledMeanings.map((entry) {
                        final originalIndex = entry.key;
                        final meaning = entry.value;
                        if (_matches.containsValue(originalIndex)) return const SizedBox.shrink();
                        return Draggable<int>(
                          data: originalIndex, // 传递原始索引
                          feedback: Material(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(meaning, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ),
                          ),
                          childWhenDragging: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(meaning, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.lightInkColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(meaning, style: const TextStyle(fontSize: 14)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('继续前行'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}