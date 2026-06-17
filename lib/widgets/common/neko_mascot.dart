import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';

enum MascotMood {
  happy,
  excited,
  thinking,
  sad,
  cheering,
  idle,
  crying,
  neutral,
}

/// Animated NekoSensei — procedural cat with mood expressions (no PNG/Lottie required).
class NekoMascot extends StatefulWidget {
  const NekoMascot({
    super.key,
    this.size = 120,
    this.mood = MascotMood.happy,
    this.showSpeechBubble,
    this.enableIdleAnimation = true,
  });

  final double size;
  final MascotMood mood;
  final String? showSpeechBubble;
  final bool enableIdleAnimation;

  @override
  State<NekoMascot> createState() => _NekoMascotState();
}

class _NekoMascotState extends State<NekoMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.enableIdleAnimation) {
      _idleController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mascot = AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        final floatY = widget.enableIdleAnimation ? -6 * _idleController.value : 0.0;
        final tailWag = widget.enableIdleAnimation
            ? math.sin(_idleController.value * math.pi * 2) * 0.15
            : 0.0;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: NekoPainter(
              mood: widget.mood,
              tailAngle: tailWag,
              blink: _idleController.value > 0.92,
            ),
          ),
        );
      },
    );

    if (widget.mood == MascotMood.excited || widget.mood == MascotMood.cheering) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.06, 1.06),
            duration: 500.ms,
          );
    } else if (widget.mood == MascotMood.sad) {
      mascot = mascot.animate().shake(hz: 2, duration: 600.ms);
    } else if (widget.mood == MascotMood.thinking) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .rotate(begin: -0.02, end: 0.02, duration: 800.ms);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSpeechBubble != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.showSpeechBubble!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.lightText,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate(key: ValueKey(widget.showSpeechBubble))
              .fadeIn(duration: 250.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),
        mascot,
      ],
    );
  }
}

class NekoPainter extends CustomPainter {
  NekoPainter({
    required this.mood,
    required this.tailAngle,
    required this.blink,
  });

  final MascotMood mood;
  final double tailAngle;
  final bool blink;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 120;

    // Tail
    final tailPaint = Paint()..color = const Color(0xFFFF9800);
    canvas.save();
    canvas.translate(cx + 28 * scale, cy + 18 * scale);
    canvas.rotate(tailAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(22 * scale, 0),
          width: 44 * scale,
          height: 12 * scale,
        ),
        Radius.circular(8 * scale),
      ),
      tailPaint,
    );
    canvas.restore();

    // Body
    final bodyPaint = Paint()..color = const Color(0xFFFF9800);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + 8 * scale),
        width: 72 * scale,
        height: 64 * scale,
      ),
      bodyPaint,
    );

    // Head
    final headPaint = Paint()..color = const Color(0xFFFFB74D);
    canvas.drawCircle(Offset(cx, cy - 18 * scale), 34 * scale, headPaint);

    // Ears
    final earPaint = Paint()..color = const Color(0xFFFF9800);
    final innerEar = Paint()..color = const Color(0xFFFFCC80);
    for (final dx in [-22.0, 22.0]) {
      final earPath = Path()
        ..moveTo(cx + dx * scale, cy - 42 * scale)
        ..lineTo(cx + (dx - 10) * scale, cy - 68 * scale)
        ..lineTo(cx + (dx + 14) * scale, cy - 48 * scale)
        ..close();
      canvas.drawPath(earPath, earPaint);
      canvas.drawCircle(
        Offset(cx + dx * scale, cy - 52 * scale),
        6 * scale,
        innerEar,
      );
    }

    // Eyes
    final eyeY = cy - 22 * scale;
    final eyeOpen = mood != MascotMood.sad &&
        mood != MascotMood.crying &&
        !blink;
    final eyePaint = Paint()..color = const Color(0xFF3C3C3C);
    for (final dx in [-14.0, 14.0]) {
      if (eyeOpen) {
        canvas.drawCircle(Offset(cx + dx * scale, eyeY), 7 * scale, eyePaint);
        canvas.drawCircle(
          Offset(cx + (dx + 2) * scale, eyeY - 2 * scale),
          2.5 * scale,
          Paint()..color = Colors.white,
        );
      } else {
        canvas.drawLine(
          Offset(cx + (dx - 6) * scale, eyeY),
          Offset(cx + (dx + 6) * scale, eyeY),
          Paint()
            ..color = eyePaint.color
            ..strokeWidth = 2.5 * scale
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF3C3C3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;
    final mouthPath = Path();
    if (mood == MascotMood.sad || mood == MascotMood.crying) {
      mouthPath.moveTo(cx - 10 * scale, cy - 2 * scale);
      mouthPath.quadraticBezierTo(
        cx, cy - 10 * scale, cx + 10 * scale, cy - 2 * scale,
      );
    } else if (mood == MascotMood.excited ||
        mood == MascotMood.cheering ||
        mood == MascotMood.happy ||
        mood == MascotMood.idle) {
      mouthPath.addOval(Rect.fromCenter(
        center: Offset(cx, cy - 4 * scale),
        width: 16 * scale,
        height: 12 * scale,
      ));
    } else {
      mouthPath.moveTo(cx - 8 * scale, cy - 4 * scale);
      mouthPath.quadraticBezierTo(
        cx, cy + 4 * scale, cx + 8 * scale, cy - 4 * scale,
      );
    }
    canvas.drawPath(mouthPath, mouthPaint);

    // Whiskers
    final whisker = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 1.5 * scale;
    for (final side in [-1.0, 1.0]) {
      for (final dy in [-4.0, 2.0, 8.0]) {
        canvas.drawLine(
          Offset(cx + side * 20 * scale, cy - 8 * scale + dy),
          Offset(cx + side * 38 * scale, cy - 6 * scale + dy),
          whisker,
        );
      }
    }

    if (mood == MascotMood.crying) {
      final tear = Paint()..color = AppColors.secondary.withValues(alpha: 0.8);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 14 * scale, eyeY + 10 * scale), width: 6 * scale, height: 10 * scale),
        tear,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 14 * scale, eyeY + 10 * scale), width: 6 * scale, height: 10 * scale),
        tear,
      );
    }

    // Sensei bell collar
    final collar = Paint()..color = AppColors.primary;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, cy + 2 * scale),
        width: 50 * scale,
        height: 10 * scale,
      ),
      collar,
    );
    canvas.drawCircle(
      Offset(cx, cy + 14 * scale),
      8 * scale,
      Paint()..color = AppColors.bellGold,
    );
    canvas.drawCircle(
      Offset(cx, cy + 14 * scale),
      8 * scale,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * scale,
    );

    // Graduation cap for thinking/cheering
    if (mood == MascotMood.thinking || mood == MascotMood.cheering) {
      final cap = Paint()..color = AppColors.secondary;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, cy - 48 * scale),
          width: 40 * scale,
          height: 8 * scale,
        ),
        cap,
      );
      canvas.drawRect(
        Rect.fromLTWH(cx - 14 * scale, cy - 68 * scale, 28 * scale, 22 * scale),
        cap,
      );
      canvas.drawCircle(
        Offset(cx + 22 * scale, cy - 44 * scale),
        5 * scale,
        Paint()..color = AppColors.bellGold,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NekoPainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.tailAngle != tailAngle ||
      oldDelegate.blink != blink;
}

class NekoLogo extends StatelessWidget {
  const NekoLogo({
    super.key,
    this.size = 160,
    this.borderRadius = 24,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.secondary.withValues(alpha: 0.08),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: NekoMascot(size: size, mood: MascotMood.cheering),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOut);
  }
}
