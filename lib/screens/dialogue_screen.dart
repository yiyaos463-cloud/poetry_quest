import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/widgets/ai_dialogue_bubble.dart';
import 'package:poetry_quest/models/poet.dart';
import 'package:poetry_quest/services/ai_service.dart';
import 'package:poetry_quest/utils/theme.dart';

class DialogueScreen extends StatefulWidget {
  const DialogueScreen({super.key});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final AiService _aiService = AiService();
  Poet? _selectedPoetLocal;
  bool _isLoadingAi = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send(GameProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final poet = _selectedPoetLocal ?? provider.selectedPoet;
    if (poet == null) {
      _showCenterDialog('提示', '请先选择一位诗人');
      return;
    }

    setState(() {
      _messages.add({'who': 'me', 'text': text});
      _isLoadingAi = true;
    });
    _controller.clear();

    try {
      final reply = await _aiService.chatWithPoet(
        poetId: poet.id,
        userMessage: text,
      );
      setState(() {
        _messages.add({'who': 'poet', 'text': reply});
      });
    } catch (e) {
      setState(() {
        _messages.add({'who': 'poet', 'text': '山高路远，音信难通... (请求失败)'});
      });
    } finally {
      setState(() => _isLoadingAi = false);
    }
  }

  void _selectPoet(Poet poet) {
    setState(() {
      _selectedPoetLocal = poet;
      _messages.clear();
      _aiService.clearHistory();
    });
    try {
      final provider = Provider.of<GameProvider>(context, listen: false);
      provider.selectPoet(poet);
    } catch (_) {}
  }

  void _showCenterDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final poet = _selectedPoetLocal ?? provider.selectedPoet;
        return Scaffold(
          body: Container(
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
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          color: AppTheme.inkColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          poet != null ? '与 ${poet.name} 对话' : '对话诗人',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.inkColor,
                          ),
                        ),
                        const Spacer(),
                        if (_isLoadingAi)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: poetsData.length,
                      itemBuilder: (ctx, i) {
                        final p = poetsData[i];
                        final selected = poet?.id == p.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => _selectPoet(p),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.accentColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: selected
                                      ? AppTheme.accentColor
                                      : AppTheme.lightInkColor.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.accentColor
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // 完整显示诗人头像
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        p.imageAsset,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : AppTheme.inkColor,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildEmptyState(poet)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (ctx, i) {
                              final msg = _messages[i];
                              final isUser = msg['who'] == 'me';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Align(
                                  alignment: isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: AiDialogueBubble(
                                    message: msg['text'] ?? '',
                                    isUser: isUser,
                                    poetImage: isUser ? null : poet?.imageAsset,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.inkColor.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: '向诗人提问或表达你的感受...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppTheme.lightInkColor.withValues(
                                alpha: 0.1,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                            minLines: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _isLoadingAi ? null : () => _send(provider),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _isLoadingAi
                                  ? AppTheme.lightInkColor
                                  : AppTheme.accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(Poet? poet) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 80,
              color: AppTheme.lightInkColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              poet != null ? '与 ${poet.name} 开始对话' : '选择一位诗人开始对话',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.inkColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              poet != null ? '可以询问诗人关于他的生平、诗歌创作或者人生感悟' : '点击上方的诗人头像选择',
              style: TextStyle(fontSize: 14, color: AppTheme.lightInkColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}