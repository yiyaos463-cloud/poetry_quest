import 'package:flutter/material.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:provider/provider.dart';

class PoemCardLayer extends StatefulWidget {
  final String poemTitle;
  final String poemLines;
  final String summary;
  final String difficulty;
  final VoidCallback onNext;
  final bool showCollectButton;

  const PoemCardLayer({
    Key? key,
    required this.poemTitle,
    required this.poemLines,
    required this.summary,
    required this.difficulty,
    required this.onNext,
    this.showCollectButton = true, // 默认显示收藏按钮
  }) : super(key: key);

  @override
  State<PoemCardLayer> createState() => _PoemCardLayerState();
}

class _PoemCardLayerState extends State<PoemCardLayer> {
  bool _collected = false;

  void _collect() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.addCollectedPoem(
      title: widget.poemTitle,
      lines: widget.poemLines,
      summary: widget.summary,
      difficulty: widget.difficulty,
    );
    setState(() => _collected = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 诗卡已收藏到“我的诗囊”'),
        duration: Duration(seconds: 1),
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
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.paperColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.inkColor.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📜 ${widget.poemTitle}',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(widget.difficulty),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.difficulty,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.poemLines,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Divider(color: AppTheme.lightInkColor.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text(
                      widget.summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (!_collected)
                ElevatedButton.icon(
                  onPressed: _collect,
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('收藏诗卡'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade400),
                    const SizedBox(width: 8),
                    Text('已收藏',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                ),
                child: const Text('完成旅程'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '简单': return Colors.green;
      case '中等': return Colors.orange;
      case '困难': return Colors.red;
      default: return Colors.grey;
    }
  }
}