import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class PoemDragFillLayer extends StatefulWidget {
  final VoidCallback onNext;
  const PoemDragFillLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<PoemDragFillLayer> createState() => _PoemDragFillLayerState();
}

class _PoemDragFillLayerState extends State<PoemDragFillLayer> {
  final List<String> _correctLines = [
    '峨眉山月半轮秋',
    '影入平羌江水流',
    '夜发清溪向三峡',
    '思君不见下渝州',
  ];
  late List<String> _shuffledLines;
  final List<String?> _placed = [null, null, null, null];
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _shuffledLines = List.from(_correctLines)..shuffle();
  }

  void _placeLine(int index, String line) {
    if (_placed[index] != null) return;
    if (_correctLines[index] != line) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('这句诗不属于这里', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() {
      _placed[index] = line;
      _shuffledLines.remove(line);
    });
    if (_placed.every((p) => p != null)) {
      setState(() => _completed = true);
    }
  }

  void _removeLine(int index) {
    if (_placed[index] == null) return;
    setState(() {
      _shuffledLines.add(_placed[index]!);
      _placed[index] = null;
      _completed = false;
    });
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
          Text('📝 将诗句拖到正确的位置', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: List.generate(4, (index) {
                  final placedLine = _placed[index];
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 70,
                        decoration: BoxDecoration(
                          color: placedLine != null ? Colors.green.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: candidateData.isNotEmpty ? AppTheme.accentColor : AppTheme.lightInkColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: placedLine != null
                            ? Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(child: Text(placedLine, style: const TextStyle(fontSize: 18))),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _removeLine(index),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  '第${index + 1}句',
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                                ),
                              ),
                      );
                    },
                    onAcceptWithDetails: (details) => _placeLine(index, details.data),
                  );
                }),
              ),
            ),
          ),
          if (!_completed)
            Container(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _shuffledLines.map((line) {
                  return Draggable<String>(
                    data: line,
                    feedback: Material(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(30)),
                        child: Text(line, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    childWhenDragging: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
                      child: Text(line, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.lightInkColor),
                      ),
                      child: Text(line, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_completed)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                child: const Text('继续前行'),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}