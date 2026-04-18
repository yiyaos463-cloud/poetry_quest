import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:poetry_quest/providers/game_provider.dart';
import 'package:poetry_quest/models/writing.dart';
import 'package:poetry_quest/utils/theme.dart';

class PoemCommunityScreen extends StatefulWidget {
  const PoemCommunityScreen({Key? key}) : super(key: key);

  @override
  State<PoemCommunityScreen> createState() => _PoemCommunityScreenState();
}

class _PoemCommunityScreenState extends State<PoemCommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  // 社区精选的写死数据
  final List<Map<String, dynamic>> _communityPoems = [
    {
      'id': '1',
      'title': '春夜喜雨',
      'content': '好雨知时节，当春乃发生。\n随风潜入夜，润物细无声。\n野径云俱黑，江船火独明。\n晓看红湿处，花重锦官城。',
      'author': '诗友·清风',
      'likes': 42,
      'comments': 8,
      'timestamp': 1713300000,
      'isLiked': false,
    },
    {
      'id': '2',
      'title': '月下独酌',
      'content': '花间一壶酒，独酌无相亲。\n举杯邀明月，对影成三人。\n月既不解饮，影徒随我身。\n暂伴月将影，行乐须及春。',
      'author': '诗友·明月',
      'likes': 56,
      'comments': 12,
      'timestamp': 1713200000,
      'isLiked': false,
    },
    {
      'id': '3',
      'title': '山居秋暝',
      'content': '空山新雨后，天气晚来秋。\n明月松间照，清泉石上流。\n竹喧归浣女，莲动下渔舟。\n随意春芳歇，王孙自可留。',
      'author': '诗友·山居',
      'likes': 38,
      'comments': 5,
      'timestamp': 1713100000,
      'isLiked': false,
    },
    {
      'id': '4',
      'title': '江雪',
      'content': '千山鸟飞绝，万径人踪灭。\n孤舟蓑笠翁，独钓寒江雪。',
      'author': '诗友·寒江',
      'likes': 67,
      'comments': 15,
      'timestamp': 1713000000,
      'isLiked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addMyPoem(GameProvider provider) async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写诗的内容')),
      );
      return;
    }
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final entry = WritingEntry(
      id: id,
      poemId: '',
      title: title.isNotEmpty ? title : '无题',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    
    await provider.addWriting(entry);
    
    _titleController.clear();
    _contentController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('诗作已保存')),
    );
    
    setState(() {});
  }

  void _deleteMyPoem(GameProvider provider, String id) async {
    await provider.deleteWriting(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('诗作已删除')),
    );
    setState(() {});
  }

  void _sharePoem(String title, String content, String author) async {
    final text = '$title\n\n$content\n\n—— $author';
    try {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('诗作已复制到剪贴板')),
      );
    } catch (e) {
      // 如果剪贴板失败，显示分享对话框
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('分享诗作'),
          content: SelectableText(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    }
  }

  void _likeCommunityPoem(String id) {
    setState(() {
      final poem = _communityPoems.firstWhere((p) => p['id'] == id);
      final isLiked = poem['isLiked'] as bool? ?? false;
      if (isLiked) {
        // 取消点赞
        poem['likes'] = (poem['likes'] as int) - 1;
        poem['isLiked'] = false;
      } else {
        // 点赞
        poem['likes'] = (poem['likes'] as int) + 1;
        poem['isLiked'] = true;
      }
    });
  }

  void _addComment(String id) {
    final TextEditingController _commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加评论'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: '写下你的评论',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final comment = _commentController.text.trim();
              if (comment.isNotEmpty) {
                setState(() {
                  final poem = _communityPoems.firstWhere((p) => p['id'] == id);
                  poem['comments'] = (poem['comments'] as int) + 1;
                  // 添加评论到评论列表
                  if (poem['commentList'] == null) {
                    poem['commentList'] = [];
                  }
                  (poem['commentList'] as List).add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'text': comment,
                    'author': '我',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('评论已提交')),
                );
              }
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }

  void _viewComments(String id) {
    final poem = _communityPoems.firstWhere((p) => p['id'] == id);
    final commentList = poem['commentList'] as List? ?? [];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('评论列表'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: commentList.isEmpty
              ? const Center(child: Text('还没有评论'))
              : ListView.builder(
                  itemCount: commentList.length,
                  itemBuilder: (context, index) {
                    final comment = commentList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['author'] ?? '匿名',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(comment['text'] ?? ''),
                            const SizedBox(height: 4),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                comment['timestamp'] ?? 0,
                              ).toString().substring(0, 16),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPoemsTab(GameProvider provider) {
    return FutureBuilder<List<WritingEntry>>(
      future: provider.getWritings(),
      builder: (context, snapshot) {
        final writings = snapshot.data ?? [];
        
        return Column(
          children: [
            // 写诗表单
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '写下你的诗',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '标题（可选）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: '内容',
                        border: OutlineInputBorder(),
                        hintText: '在这里写下你的诗...',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addMyPoem(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                        ),
                        child: const Text('保存我的诗'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 我的诗作列表
            Expanded(
              child: writings.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('还没有诗作，开始创作吧！'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: writings.length,
                      itemBuilder: (context, index) {
                        final poem = writings[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      poem.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteMyPoem(provider, poem.id),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: '删除',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  poem.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '发布于 ${DateTime.fromMillisecondsSinceEpoch(poem.timestamp).toString().substring(0, 16)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () => _sharePoem(poem.title, poem.content, '我'),
                                      icon: const Icon(Icons.share),
                                      tooltip: '分享',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommunityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _communityPoems.length,
      itemBuilder: (context, index) {
        final poem = _communityPoems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poem['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '作者: ${poem['author']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  poem['content'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _likeCommunityPoem(poem['id']),
                          icon: Icon(
                            (poem['isLiked'] as bool? ?? false) 
                                ? Icons.favorite 
                                : Icons.favorite_border,
                            color: (poem['isLiked'] as bool? ?? false) 
                                ? Colors.red 
                                : Colors.grey,
                          ),
                          tooltip: '点赞',
                        ),
                        Text('${poem['likes']}'),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => _addComment(poem['id']),
                          icon: const Icon(Icons.comment),
                          tooltip: '评论',
                        ),
                        Text('${poem['comments']}'),
                      ],
                    ),
                    Row(
                      children: [
                        if ((poem['commentList'] as List?)?.isNotEmpty ?? false)
                          IconButton(
                            onPressed: () => _viewComments(poem['id']),
                            icon: const Icon(Icons.list),
                            tooltip: '查看评论',
                          ),
                        IconButton(
                          onPressed: () => _sharePoem(
                            poem['title'],
                            poem['content'],
                            poem['author'],
                          ),
                          icon: const Icon(Icons.share),
                          tooltip: '分享',
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('我要写诗'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '我的诗作'),
                Tab(text: '社区精选'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMyPoemsTab(provider),
              _buildCommunityTab(),
            ],
          ),
        );
      },
    );
  }
}