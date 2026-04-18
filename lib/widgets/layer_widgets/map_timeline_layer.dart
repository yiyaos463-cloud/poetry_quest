import 'package:flutter/material.dart';
import 'package:poetry_quest/utils/theme.dart';

class MapTimelineLayer extends StatefulWidget {
  final VoidCallback onNext;
  const MapTimelineLayer({Key? key, required this.onNext}) : super(key: key);

  @override
  State<MapTimelineLayer> createState() => _MapTimelineLayerState();
}

class _MapTimelineLayerState extends State<MapTimelineLayer>
    with SingleTickerProviderStateMixin {
  final List<String> _correctOrder = ['峨眉山', '平羌江', '清溪', '三峡', '渝州'];
  final Map<int, String> _placed = {};
  late List<String> _remaining;
  int _boatPos = -1;
  late AnimationController _boatController;
  late Animation<double> _boatAnimation;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _remaining = List.from(_correctOrder)..shuffle();
    _boatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _boatController.dispose();
    super.dispose();
  }

  void _placeName(int index, String name) {
    if (_placed.containsKey(index)) return;
    if (_correctOrder[index] != name) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('再读读诗，顺序不对哦'), duration: Duration(seconds: 1)),
      );
      return;
    }
    setState(() {
      _placed[index] = name;
      _remaining.remove(name);
      _boatPos = _placed.length - 1;
    });
    _animateBoatTo(_boatPos);
    if (_placed.length == 5) {
      setState(() => _completed = true);
    }
  }

  void _animateBoatTo(int targetIndex) {
    _boatAnimation = Tween<double>(
      begin: _boatPos >= 0 ? (_boatPos - 1).clamp(0, 4) * 1.0 : 0.0,
      end: targetIndex * 1.0,
    ).animate(CurvedAnimation(parent: _boatController, curve: Curves.easeInOut));
    _boatController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.paperColor, AppTheme.lightInkColor.withValues(alpha: 0.2)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text('📍 将地名按诗中顺序排列', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            '峨眉山 → 平羌江 → 清溪 → 三峡 → 渝州',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double slotWidth = constraints.maxWidth / 5;
                const double lineY = 60.0;
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: lineY,
                      child: CustomPaint(
                        painter: _TimelinePainter(
                          filledCount: _placed.length,
                          slotWidth: slotWidth,
                          lineY: 0,
                        ),
                        size: Size(constraints.maxWidth, 20),
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return SizedBox(
                          width: slotWidth,
                          child: DragTarget<String>(
                            builder: (context, candidateData, rejectedData) {
                              final placedName = _placed[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.only(bottom: 35),
                                decoration: BoxDecoration(
                                  color: placedName != null
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: candidateData.isNotEmpty
                                      ? Border.all(color: AppTheme.accentColor, width: 2)
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (placedName != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.green, width: 2),
                                        ),
                                        child: Text(
                                          placedName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade100,
                                          border: Border.all(color: Colors.grey.shade400),
                                        ),
                                        child: const Icon(Icons.add, color: Colors.grey, size: 20),
                                      ),
                                  ],
                                ),
                              );
                            },
                            onAcceptWithDetails: (details) => _placeName(index, details.data),
                          ),
                        );
                      }),
                    ),
                    if (_boatPos >= 0)
                      AnimatedBuilder(
                        animation: _boatController,
                        builder: (context, child) {
                          final double boatX = _boatAnimation.value * slotWidth + slotWidth / 2 - 30;
                          return Positioned(
                            left: boatX,
                            top: lineY - 25, // 上移，避免遮挡文字
                            child: child!,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.directions_boat, size: 22, color: Colors.brown),
                              SizedBox(width: 4),
                              Text('轻舟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _remaining.map((name) {
              return Draggable<String>(
                data: name,
                feedback: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                    child: Text(name, style: const TextStyle(fontSize: 16)),
                  ),
                ),
                childWhenDragging: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(name, style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.lightInkColor),
                  ),
                  child: Text(name, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          if (_completed)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: widget.onNext,
                child: const Text('继续前行'),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final int filledCount;
  final double slotWidth;
  final double lineY;

  _TimelinePainter({
    required this.filledCount,
    required this.slotWidth,
    required this.lineY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final filledPaint = Paint()
      ..color = AppTheme.accentColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final x1 = i * slotWidth + slotWidth / 2;
      final x2 = (i + 1) * slotWidth + slotWidth / 2;
      canvas.drawLine(
        Offset(x1, lineY),
        Offset(x2, lineY),
        i < filledCount ? filledPaint : paint,
      );
    }
    for (int i = 0; i < 5; i++) {
      final x = i * slotWidth + slotWidth / 2;
      canvas.drawCircle(
        Offset(x, lineY),
        6,
        Paint()..color = i < filledCount ? AppTheme.accentColor : Colors.grey.shade400,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) =>
      oldDelegate.filledCount != filledCount ||
      oldDelegate.slotWidth != slotWidth ||
      oldDelegate.lineY != lineY;
}