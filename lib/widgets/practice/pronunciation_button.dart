import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';

class PronunciationButton extends StatefulWidget {
  const PronunciationButton({
    super.key,
    required this.japanese,
    required this.audio,
    this.size = 56,
    this.label,
  });

  final String japanese;
  final AudioService audio;
  final double size;
  final String? label;

  @override
  State<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends State<PronunciationButton> {
  bool _playing = false;

  Future<void> _play({bool slow = false}) async {
    setState(() => _playing = true);
    if (slow) {
      await widget.audio.speakSlow(widget.japanese);
    } else {
      await widget.audio.speakJapanese(widget.japanese);
    }
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _play(),
          onLongPress: () => _play(slow: true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _playing
                    ? [AppColors.accent, AppColors.nekoOrange]
                    : [AppColors.secondary, AppColors.secondaryDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  blurRadius: _playing ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _playing ? Icons.graphic_eq : Icons.volume_up_rounded,
              color: Colors.white,
              size: widget.size * 0.45,
            ),
          ),
        )
            .animate(target: _playing ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
        if (widget.label != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 2),
        Text(
          'Hold for slow',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
