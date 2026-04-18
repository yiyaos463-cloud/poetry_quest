import 'package:flutter/material.dart';
import 'package:poetry_quest/models/game_level.dart';
import 'package:poetry_quest/utils/theme.dart';

class ChoiceLayer extends StatefulWidget {
  final VoidCallback onNext;
  final LayerData? layerData;
  final String difficulty;

  const ChoiceLayer({
    Key? key, 
    required this.onNext,
    this.layerData,
    required this.difficulty,
  }) : super(key: key);

  @override
  State<ChoiceLayer> createState() => _ChoiceLayerState();
}

class _ChoiceLayerState extends State<ChoiceLayer> {
  int? _selectedOption;
  bool _answered = false;

  void _checkOption(int? value) {
    setState(() {
      _selectedOption = value;
    });
  }

  void _submitAnswer() {
    if (widget.layerData?.options != null && _selectedOption != null) {
      final option = widget.layerData!.options![_selectedOption!];
      if (option.isCorrect) {
        _showCorrectDialog(option.feedback ?? '回答正确！');
      } else {
        _showHintDialog(option.feedback ?? '再想想看...');
      }
    } else {
      // 如果没有选项数据，直接进入下一层
      widget.onNext();
    }
  }

  void _showCorrectDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ 正确'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _answered = true;
              });
              // 延迟一下然后进入下一层
              Future.delayed(const Duration(milliseconds: 500), () {
                widget.onNext();
              });
            },
            child: const Text('继续'),
          ),
        ],
      ),
    );
  }

  void _showHintDialog(String hint) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('💡 再想想'),
        content: Text(hint),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layer = widget.layerData;
    
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (layer?.title != null) ...[
              Text(
                layer!.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
            ],
            
            if (layer?.description != null) ...[
              Text(
                layer!.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            
            if (layer?.promptQuestion != null) ...[
              Text(
                layer!.promptQuestion!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // 显示选项
            if (layer?.options != null && layer!.options!.isNotEmpty) ...[
              ...layer!.options!.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: _checkOption,
                  title: Text(option.text, style: const TextStyle(fontSize: 16)),
                  activeColor: AppTheme.accentColor,
                );
              }).toList(),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedOption != null ? _submitAnswer : null,
                  child: const Text('提交答案'),
                ),
              ),
            ] else if (layer?.contextInfo != null) ...[
              // 如果是context层，显示背景信息
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.lightInkColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  layer!.contextInfo!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onNext(),
                  child: const Text('继续'),
                ),
              ),
            ] else ...[
              // 如果没有数据，显示默认内容
              Text(
                '请做出你的选择',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onNext(),
                  child: const Text('继续'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}