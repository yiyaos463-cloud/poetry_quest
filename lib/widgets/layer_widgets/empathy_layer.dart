import 'package:flutter/material.dart';
import 'package:poetry_quest/models/game_level.dart';
import 'package:poetry_quest/utils/theme.dart';

class EmpathyLayer extends StatelessWidget {
  final LayerData layerData;
  final VoidCallback onNext;

  const EmpathyLayer({Key? key, required this.layerData, required this.onNext})
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
          const SizedBox(height: 32),
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
              children: [
                Icon(
                  Icons.person,
                  size: 48,
                  color: AppTheme.inkColor.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  '李白此刻的独白',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  '“行路难！行路难！多歧路，今安在？”',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
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
                onPressed: onNext,
                child: Text(option.text),
              ),
            );
          }),
        ],
      ),
    );
  }
}
