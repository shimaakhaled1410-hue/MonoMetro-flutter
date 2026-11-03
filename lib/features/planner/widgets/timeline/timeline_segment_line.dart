import 'package:flutter/material.dart';

/// Vertical connector between two timeline stops. Walking segments are
/// dotted so they stay distinguishable from transit lines without relying
/// on color alone.
class TimelineSegmentLine extends StatelessWidget {
  const TimelineSegmentLine({
    super.key,
    required this.color,
    this.dotted = false,
  });

  final Color color;
  final bool dotted;

  @override
  Widget build(BuildContext context) {
    if (!dotted) return SizedBox(width: 3, child: ColoredBox(color: color));
    return SizedBox(width: 3, child: CustomPaint(painter: _DotsPainter(color)));
  }
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter(this.color);

  final Color color;

  static const double _radius = 1.5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = _radius * 2 + _gap;
    for (var y = _radius; y <= size.height - _radius; y += step) {
      canvas.drawCircle(Offset(size.width / 2, y), _radius, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => oldDelegate.color != color;
}
