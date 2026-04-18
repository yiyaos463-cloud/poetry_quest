import 'package:flutter/material.dart';

class HardContextLayer extends StatefulWidget {
  final VoidCallback onNext;
  const HardContextLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<HardContextLayer> createState() => _HardContextLayerState();
}

class _HardContextLayerState extends State<HardContextLayer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _timeline = [
    {'title': '离蜀', 'desc': '24岁，仗剑去国，辞亲远游', 'image': 'assets/images/libai.png'},
    {'title': '入京', 'desc': '42岁，奉诏入京，供奉翰林', 'image': 'assets/images/libai.png'},
    {'title': '赐金放还', 'desc': '44岁，遭谗被疏，赐金放还', 'image': 'assets/images/libai.png'},
    {'title': '流放', 'desc': '58岁，卷入永王案，流放夜郎', 'image': 'assets/images/libai.png'},
    {'title': '遇赦', 'desc': '59岁，白帝遇赦，轻舟东归', 'image': 'assets/images/libai.png'},
  ];

  void _nextPage() {
    if (_currentPage < _timeline.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF1A237E), Colors.black87],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '李白的一生',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '《峨眉山月歌》是这一切的起点',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _timeline.length,
              itemBuilder: (context, index) {
                final item = _timeline[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 完整显示诗人形象
                        Container(
                          height: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item['title']!,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['desc']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '第 ${index + 1} / ${_timeline.length} 站',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentPage > 0 ? _previousPage : null,
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                Text(
                  '${_currentPage + 1} / ${_timeline.length}',
                  style: const TextStyle(color: Colors.white70),
                ),
                IconButton(
                  onPressed: _currentPage < _timeline.length - 1 ? _nextPage : null,
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
            child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('继续前行'),
            ),
          ),
        ],
      ),
    );
  }
}