import 'package:flutter/material.dart';
import 'package:poetry_quest/models/game_level.dart';
import 'package:poetry_quest/utils/theme.dart';

class WrongIntLayer extends StatelessWidget {
  final LayerData layerData;
  final VoidCallback onNext;

  const WrongIntLayer({Key? key, required this.layerData, required this.onNext})
    : super(key: key);

  void _showExplanationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ 正解'),
        content: Text(layerData.correctExplanation!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onNext();
            },
            child: const Text('继续'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            layerData.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Text(
                  'AI',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    layerData.wrongInterpretation!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '🤔 你认为AI学徒错在哪里？',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ...layerData.options!.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightInkColor.withOpacity(0.1),
                  foregroundColor: AppTheme.inkColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: AppTheme.lightInkColor.withOpacity(0.3),
                    ),
                  ),
                ),
                onPressed: () {
                  if (option.isCorrect) {
                    _showExplanationDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(option.feedback ?? '再读读诗的最后两句？'),
                        backgroundColor: AppTheme.accentColor,
                      ),
                    );
                  }
                },
                child: Text(option.text),
              ),
            );
          }),
        ],
      ),
    );
  }
}
