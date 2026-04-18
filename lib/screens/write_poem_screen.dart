import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/models/writing.dart';

class WritePoemScreen extends StatefulWidget {
  final WritingEntry? entry;

  const WritePoemScreen({super.key, this.entry});

  @override
  State<WritePoemScreen> createState() => _WritePoemScreenState();
}

class _WritePoemScreenState extends State<WritePoemScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  bool get isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleCtrl.text = widget.entry!.title;
      _contentCtrl.text = widget.entry!.content;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save(GameProvider provider) async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('标题和内容都不能为空')));
      return;
    }
    final poemId = provider.selectedPoem?.id ?? '';

    if (isEditing) {
      final updated = widget.entry!.copyWith(
        title: title,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        poemId: poemId,
      );
      await provider.updateWriting(updated);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已更新写诗记录')));
      Navigator.pop(context);
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final entry = WritingEntry(
      id: id,
      poemId: poemId,
      title: title,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await provider.addWriting(entry);
    _titleCtrl.clear();
    _contentCtrl.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已保存写诗记录')));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('我要写诗')),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: '标题（可选）'),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: _contentCtrl,
                    decoration: const InputDecoration(
                      hintText: '在这里写下你的诗（支持多行）',
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _save(provider),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('保存写诗历史'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
