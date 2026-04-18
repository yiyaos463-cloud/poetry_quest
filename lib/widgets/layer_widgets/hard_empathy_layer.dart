import 'package:flutter/material.dart';

class HardEmpathyLayer extends StatefulWidget {
  final VoidCallback onNext;
  const HardEmpathyLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<HardEmpathyLayer> createState() => _HardEmpathyLayerState();
}

class _HardEmpathyLayerState extends State<HardEmpathyLayer> {
  bool _chosen = false;
  bool _showStars = false;

  void _makeChoice() {
    setState(() {
      _chosen = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _showStars = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/hard_starry_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          if (!_chosen)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '如果知道这一走再也回不去，\n李白还会出发吗？',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ChoiceCard(
                          title: '会的',
                          subtitle: '好男儿志在四方',
                          color: const Color(0xFF2C3E50), // 深蓝灰
                          onTap: _makeChoice,
                        ),
                        const SizedBox(width: 20),
                        _ChoiceCard(
                          title: '或许不会',
                          subtitle: '故乡难离',
                          color: const Color(0xFFD4A373), // 暖棕色
                          onTap: _makeChoice,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _showStars ? 1.0 : 0.0,
                    duration: const Duration(seconds: 2),
                    child: Column(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 40),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '“长风破浪会有时”',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '“轻舟已过万重山”',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '这是万里远游的起点，\n也是诗仙一生的序章。',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_showStars)
                    ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      ),
                      child: const Text('继续前行'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120, // 固定高度，保证等大
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}