import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';

enum MascotMood { happy, excited, thinking, sad, cheering }

/// Animated NekoSensei mascot — idle float, bounce, wiggle per mood.
class NekoMascot extends StatefulWidget {
  const NekoMascot({
    super.key,
    this.size = 120,
    this.mood = MascotMood.happy,
    this.showSpeechBubble,
    this.animate = true,
  });

  final double size;
  final MascotMood mood;
  final String? showSpeechBubble;
  final bool animate;

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
    if (widget.animate) {
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
    final mood = widget.mood;

    Widget mascot = AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        final floatY = widget.animate ? -6 * _idleController.value : 0.0;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: child,
        );
      },
      child: Transform.scale(
        scale: _moodScale(mood),
        child: Image.asset(
          AppAssets.logo,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.pets,
            size: widget.size * 0.6,
            color: AppColors.primary,
          ),
        ),
      ),
    );

    if (mood == MascotMood.excited || mood == MascotMood.cheering) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.06, 1.06),
            duration: 500.ms,
            curve: Curves.easeInOut,
          );
    } else if (mood == MascotMood.sad) {
      mascot = mascot.animate().shake(hz: 2, duration: 600.ms);
    } else if (mood == MascotMood.thinking) {
      mascot = mascot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .rotate(begin: -0.02, end: 0.02, duration: 800.ms);
    } else if (widget.animate) {
      mascot = mascot.animate().fadeIn(duration: 400.ms);
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

  double _moodScale(MascotMood mood) => switch (mood) {
        MascotMood.excited || MascotMood.cheering => 1.08,
        MascotMood.sad => 0.92,
        _ => 1.0,
      };
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
        child: Image.asset(
          AppAssets.logo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: AppColors.secondary,
            child: const Icon(Icons.pets, color: Colors.white, size: 64),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOut);
  }
}
