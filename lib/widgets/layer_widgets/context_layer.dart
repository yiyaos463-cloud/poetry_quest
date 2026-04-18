import 'package:flutter/material.dart';
import 'package:poetry_quest/models/game_level.dart';
import 'package:poetry_quest/utils/theme.dart';

class ContextLayer extends StatelessWidget {
  final LayerData layerData;
  final VoidCallback onNext;

  const ContextLayer({Key? key, required this.layerData, required this.onNext})
    : super(key: key);

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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.paperColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightInkColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📜 历史背景',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  layerData.contextInfo!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            layerData.promptQuestion!,
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
                    onNext();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(option.feedback ?? '再想想...'),
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
