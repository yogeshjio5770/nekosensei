import 'package:flutter/material.dart';
import 'dart:ui';
import '../../config/constants.dart';

class KanjiCanvas extends StatefulWidget {
  final String kanji;
  final VoidCallback onPassed;

  const KanjiCanvas({
    super.key,
    required this.kanji,
    required this.onPassed,
  });

  @override
  State<KanjiCanvas> createState() => _KanjiCanvasState();
}

class _KanjiCanvasState extends State<KanjiCanvas> {
  List<Offset?> _points = [];
  bool _isPassed = false;

  void _clear() {
    setState(() {
      _points.clear();
      _isPassed = false;
    });
  }

  void _check() {
    // Basic validation: User must draw at least 10 points. 
    // In a real app with ML, we'd pass _points to Google ML Kit Digital Ink Recognition.
    if (_points.where((p) => p != null).length > 10) {
      setState(() {
        _isPassed = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onPassed();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please trace the full Kanji!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Trace the Kanji: ${widget.kanji}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 3),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background hint
              Center(
                child: Text(
                  widget.kanji,
                  style: TextStyle(
                    fontSize: 200,
                    color: Colors.grey.withValues(alpha: 0.2),
                    fontFamily: 'NotoSansJP',
                  ),
                ),
              ),
              // Drawing layer
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _points.add(null);
                  });
                },
                child: CustomPaint(
                  painter: _DrawingPainter(
                    points: _points,
                    color: _isPassed ? AppColors.success : AppColors.primary,
                  ),
                  size: const Size(300, 300),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.check),
              label: const Text('Check Stroke'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  _DrawingPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
