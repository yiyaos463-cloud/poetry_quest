import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class AiDialogueBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String? poetImage;

  const AiDialogueBubble({
    Key? key, 
    required this.message, 
    this.isUser = false,
    this.poetImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: AppTheme.inkColor,
              backgroundImage: poetImage != null 
                  ? AssetImage(poetImage!) 
                  : null,
              child: poetImage == null 
                  ? const Text('诗', style: TextStyle(color: Colors.white))
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.accentColor.withValues(alpha: 0.15)
                    : AppTheme.paperColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUser 
                      ? AppTheme.accentColor.withValues(alpha: 0.3)
                      : AppTheme.lightInkColor.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.inkColor.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppTheme.inkColor,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppTheme.lightInkColor,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}