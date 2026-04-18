import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poetry_quest/utils/theme.dart';

class MyPoemsScreen extends StatefulWidget {
  const MyPoemsScreen({Key? key}) : super(key: key);

  @override
  State<MyPoemsScreen> createState() => _MyPoemsScreenState();
}

class _MyPoemsScreenState extends State<MyPoemsScreen> {
  final List<Map<String, dynamic>> _myPoems = [
    {
      'id': 1,
      'title': '春日游',
      'content': '春风拂面柳絮飞，\n桃花流水鳜鱼肥。\n青山绿水常相伴，\n诗意盎然满载归。',
      'likes': 128,
      'comments': 15,
      'date': '2024-03-15',
    },
    {
      'id': 2,
      'title': '思乡',
      'content': '明月几时有，\n照我思故乡。\n举头望明月，\n低头泪两行。',
      'likes': 256,
      'comments': 32,
      'date': '2024-03-10',
    },
  ];

  final List<Map<String, dynamic>> _communityPoems = [
    {
      'id': 3,
      'author': '小明',
      'title': '秋夜',
      'content': '秋风起，叶飘零。\n明月照，独立庭。\n思故人，泪满襟。',
      'likes': 89,
      'comments': 8,
      'date': '2024-03-18',
      'isLiked': false,
    },
    {
      'id': 4,
      'author': '小红',
      'title': '登山',
      'content': '登高望远天地宽，\n云海翻腾胸臆间。\n一览众山小，\n心随鸿雁飞。',
      'likes': 156,
      'comments': 21,
      'date': '2024-03-17',
      'isLiked': true,
    },
    {
      'id': 5,
      'author': '小刚',
      'title': '送别',
      'content': '长亭外，古道边。\n芳草碧连天。\n晚风拂柳笛声残，\n夕阳山外山。',
      'likes': 234,
      'comments': 45,
      'date': '2024-03-16',
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '我的诗作',
            style: TextStyle(color: AppTheme.inkColor),
          ),
          backgroundColor: AppTheme.paperColor,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppTheme.accentColor,
            unselectedLabelColor: AppTheme.lightInkColor,
            indicatorColor: AppTheme.accentColor,
            tabs: const [
              Tab(text: '我的作品'),
              Tab(text: '社区精选'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyPoemsTab(),
            _buildCommunityTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showWritePoemDialog(context),
          backgroundColor: AppTheme.accentColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMyPoemsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myPoems.length,
      itemBuilder: (context, index) {
        final poem = _myPoems[index];
        return _buildPoemCard(
          title: poem['title'],
          content: poem['content'],
          likes: poem['likes'],
          comments: poem['comments'],
          date: poem['date'],
          isMyPoem: true,
          onShare: () => _sharePoem(poem),
          onDelete: () => _deletePoem(index),
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
        return _buildCommunityPoemCard(
          author: poem['author'],
          title: poem['title'],
          content: poem['content'],
          likes: poem['likes'],
          comments: poem['comments'],
          date: poem['date'],
          isLiked: poem['isLiked'],
          onLike: () => _toggleLike(index),
          onComment: () => _showComments(context, index),
        );
      },
    );
  }

  Widget _buildPoemCard({
    required String title,
    required String content,
    required int likes,
    required int comments,
    required String date,
    required bool isMyPoem,
    VoidCallback? onShare,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.inkColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.inkColor,
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: AppTheme.lightInkColor),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 20),
                        SizedBox(width: 8),
                        Text('分享'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('删除', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'share') onShare?.call();
                  if (value == 'delete') onDelete?.call();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: AppTheme.inkColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite, size: 18, color: Colors.red[300]),
              const SizedBox(width: 4),
              Text('$likes'),
              const SizedBox(width: 16),
              Icon(Icons.comment, size: 18, color: AppTheme.lightInkColor),
              const SizedBox(width: 4),
              Text('$comments'),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightInkColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityPoemCard({
    required String author,
    required String title,
    required String content,
    required int likes,
    required int comments,
    required String date,
    required bool isLiked,
    VoidCallback? onLike,
    VoidCallback? onComment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.inkColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.accentColor.withValues(alpha: 0.2),
                child: Text(
                  author[0],
                  style: TextStyle(color: AppTheme.accentColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                author,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkColor,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightInkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.inkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: AppTheme.inkColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isLiked ? Colors.red : AppTheme.lightInkColor,
                    ),
                    const SizedBox(width: 4),
                    Text('$likes'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onComment,
                child: Row(
                  children: [
                    Icon(Icons.comment, size: 18, color: AppTheme.lightInkColor),
                    const SizedBox(width: 4),
                    Text('$comments'),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                color: AppTheme.lightInkColor,
                onPressed: () => _sharePoem({'title': title, 'content': content}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWritePoemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('创作诗词'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  hintText: '请输入诗题',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: '内容',
                  hintText: '请输入诗句（每句一行）',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  _myPoems.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'title': titleController.text,
                    'content': contentController.text,
                    'likes': 0,
                    'comments': 0,
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('发布成功！')),
                );
              }
            },
            child: const Text('发布'),
          ),
        ],
      ),
    );
  }

  void _sharePoem(Map<String, dynamic> poem) {
    final text = '【${poem['title']}】\n${poem['content']}\n\n——来自诗境闯关';
    Clipboard.setData(ClipboardData(text: text));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('分享'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('诗词已复制到剪贴板'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightInkColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _deletePoem(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除'),
        content: const Text('确定要删除这首诗吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _myPoems.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleLike(int index) {
    setState(() {
      _communityPoems[index]['isLiked'] = !_communityPoems[index]['isLiked'];
      _communityPoems[index]['likes'] += _communityPoems[index]['isLiked'] ? 1 : -1;
    });
  }

  void _showComments(BuildContext context, int index) {
    final poem = _communityPoems[index];
    final commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '评论',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.inkColor,
                ),
              ),
              const SizedBox(height: 16),
              // 示例评论
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightInkColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('网友A：', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('写得太好了！'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lightInkColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('网友B：', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('很有诗意，赞！'),
                  ],
                ),
              ),
              // 输入评论
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: '写下你的评论...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: AppTheme.accentColor),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('评论成功！')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}