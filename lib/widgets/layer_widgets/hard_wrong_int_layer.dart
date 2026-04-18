import 'package:flutter/material.dart';

class HardWrongIntLayer extends StatefulWidget {
  final VoidCallback onNext;
  const HardWrongIntLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<HardWrongIntLayer> createState() => _HardWrongIntLayerState();
}

class _HardWrongIntLayerState extends State<HardWrongIntLayer> {
  final List<String> _targets = ['🌙 明月', '🏔️ 故乡', '👥 亲友'];
  final Map<String, bool> _discovered = {};

  void _showExplanation(String target) {
    String explanation = '';
    if (target == '🌙 明月') {
      explanation = '“举头望明月，低头思故乡。”\n月是李白思乡的寄托，“君”亦是那一轮明月。';
    } else if (target == '🏔️ 故乡') {
      explanation = '“仍怜故乡水，万里送行舟。”\n故乡的山水是李白永远的眷恋，“君”也是那片故土。';
    } else {
      explanation = '“思君不见下渝州。”\n“君”亦是故乡的亲友，是离别时的不舍。';
    }
    setState(() {
      _discovered[target] = true;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(target),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('领悟了'),
          ),
        ],
      ),
    );
  }

  bool get _allDiscovered => _discovered.length == 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          colors: [Colors.indigo.shade800, Colors.black],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '思君不见',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '将“君”拖到不同的对象上，探索它的含义',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 30),
              Draggable<String>(
                data: '君',
                feedback: Material(
                  color: Colors.transparent,
                  child: Text(
                    '君',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade200,
                      shadows: [Shadow(color: Colors.black, blurRadius: 15)],
                    ),
                  ),
                ),
                child: Text(
                  '君',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade100,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Wrap(
                spacing: 30,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _targets.map((target) {
                  final discovered = _discovered[target] ?? false;
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: discovered
                              ? Colors.green.withValues(alpha: 0.3)
                              : Colors.transparent,
                          border: Border.all(
                            color: candidateData.isNotEmpty
                                ? Colors.amber
                                : (discovered ? Colors.greenAccent : Colors.white30),
                            width: 3,
                          ),
                          boxShadow: discovered
                              ? [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 20)]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(target, style: const TextStyle(color: Colors.white, fontSize: 16)),
                            if (discovered) const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                          ],
                        ),
                      );
                    },
                    onAcceptWithDetails: (details) {
                      if (details.data == '君') {
                        _showExplanation(target);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              if (_allDiscovered)
                ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
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