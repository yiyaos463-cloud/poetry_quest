import 'package:flutter/material.dart';

class HardRevealLayer extends StatefulWidget {
  final String poemTitle;
  final String poemLines;
  final String summary;
  final VoidCallback onNext;

  const HardRevealLayer({
    Key? key,
    required this.poemTitle,
    required this.poemLines,
    required this.summary,
    required this.onNext,
  }) : super(key: key);

  @override
  State<HardRevealLayer> createState() => _HardRevealLayerState();
}

class _HardRevealLayerState extends State<HardRevealLayer> {
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF0B1A3D), Colors.black87],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_submitted) ...[
                const Text(
                  '写下你想对24岁的李白说的话',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  '封存在时光胶囊中，沉入江底，化作星辰',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    hintText: '例如：你的诗，让我也想出发了..',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _submitted = true),
                  icon: const Icon(Icons.rocket_launch),
                  label: const Text('封存时光胶囊'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.poemTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.poemLines,
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white30),
                      const SizedBox(height: 16),
                      Text(
                        '给24岁的李白：\n"${_controller.text.trim()}"',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.summary,
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: const Text('完成旅程'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}