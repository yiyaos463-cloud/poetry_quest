import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class GeneralRevealLayer extends StatefulWidget {
  final String poemTitle;
  final String poemLines;
  final String summary;
  final VoidCallback onNext;

  const GeneralRevealLayer({
    Key? key,
    required this.poemTitle,
    required this.poemLines,
    required this.summary,
    required this.onNext,
  }) : super(key: key);

  @override
  State<GeneralRevealLayer> createState() => _GeneralRevealLayerState();
}

class _GeneralRevealLayerState extends State<GeneralRevealLayer> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _cardKey = GlobalKey();
  bool _generated = false;

  Future<void> _generateAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final buffer = byteData.buffer;
        await Share.shareXFiles([
          XFile.fromData(
            buffer.asUint8List(),
            name: '诗卡.png',
            mimeType: 'image/png',
          ),
        ], text: '我的《峨眉山月歌》专属路线图');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('生成失败，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/emei/layer_panorama.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (!_generated) ...[
                Text(
                  '写下你的一次“出发”经历',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '例如：升学、搬家、第一次离家...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => _generated = true),
                  child: const Text('生成我的路线图'),
                ),
              ] else ...[
                RepaintBoundary(
                  key: _cardKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.paperColor.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/emei/layer_panorama.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.poemTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.poemLines,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          '我的出发：${_controller.text}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.summary,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _generateAndShare,
                      icon: const Icon(Icons.share),
                      label: const Text('分享诗卡'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: widget.onNext,
                      child: const Text('完成旅程'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}