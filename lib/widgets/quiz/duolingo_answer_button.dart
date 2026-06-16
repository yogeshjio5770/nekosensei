import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/haptic_service.dart';

enum AnswerButtonState { normal, selected, correct, incorrect, disabled }

class DuolingoAnswerButton extends StatefulWidget {
  const DuolingoAnswerButton({
    super.key,
    required this.label,
    required this.number,
    required this.state,
    required this.onTap,
  });

  final String label;
  final int number;
  final AnswerButtonState state;
  final VoidCallback onTap;

  @override
  State<DuolingoAnswerButton> createState() => _DuolingoAnswerButtonState();
}

class _DuolingoAnswerButtonState extends State<DuolingoAnswerButton> {
  bool _pressed = false;

  Color get _borderColor => switch (widget.state) {
        AnswerButtonState.correct => AppColors.successDark,
        AnswerButtonState.incorrect => AppColors.errorDark,
        AnswerButtonState.selected => AppColors.secondary,
        AnswerButtonState.disabled => AppColors.skillLocked,
        _ => const Color(0xFFD4D4D4),
      };

  Color get _bgColor => switch (widget.state) {
        AnswerButtonState.correct => AppColors.success.withValues(alpha: 0.15),
        AnswerButtonState.incorrect => AppColors.error.withValues(alpha: 0.12),
        AnswerButtonState.selected =>
          AppColors.secondary.withValues(alpha: 0.1),
        AnswerButtonState.disabled => AppColors.skillPath,
        _ => Colors.white,
      };

  Color get _numberColor => switch (widget.state) {
        AnswerButtonState.correct => AppColors.success,
        AnswerButtonState.incorrect => AppColors.error,
        AnswerButtonState.selected => AppColors.secondary,
        _ => AppColors.lightTextSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final enabled = widget.state != AnswerButtonState.disabled;

    Widget button = GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              HapticService.selection();
              widget.onTap();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          0,
          _pressed && enabled ? 4 : 0,
          0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            top: BorderSide(color: _borderColor.withValues(alpha: 0.3), width: 2),
            left: BorderSide(color: _borderColor.withValues(alpha: 0.5), width: 2),
            right: BorderSide(color: _borderColor.withValues(alpha: 0.5), width: 2),
            bottom: BorderSide(
              color: _borderColor,
              width: _pressed && enabled ? 2 : 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _numberColor, width: 2),
              ),
              child: Center(
                child: Text(
                  '${widget.number}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _numberColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? AppColors.lightText
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            if (widget.state == AnswerButtonState.correct)
              const Icon(Icons.check_circle, color: AppColors.success),
            if (widget.state == AnswerButtonState.incorrect)
              const Icon(Icons.cancel, color: AppColors.error),
          ],
        ),
      ),
    );

    if (widget.state == AnswerButtonState.incorrect) {
      button = button.animate().shake(hz: 4, duration: 400.ms);
    }

    if (widget.state == AnswerButtonState.correct) {
      button = button.animate().scale(
            begin: const Offset(1, 1),
            end: const Offset(1.02, 1.02),
            duration: 200.ms,
            curve: Curves.elasticOut,
          );
    }

    return button;
  }
}
