import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/haptic_service.dart';

/// Type-in answer with optional Duolingo-style word bank chips.
class TypeAnswerField extends StatelessWidget {
  const TypeAnswerField({
    super.key,
    required this.controller,
    required this.wordBank,
    required this.onChanged,
    this.showFeedback = false,
    this.isCorrect = false,
    this.correctAnswer = '',
  });

  final TextEditingController controller;
  final List<String> wordBank;
  final ValueChanged<String> onChanged;
  final bool showFeedback;
  final bool isCorrect;
  final String correctAnswer;

  void _tapChip(String word) {
    if (showFeedback) return;
    HapticService.selection();
    controller.text = word;
    onChanged(word);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = showFeedback
        ? (isCorrect ? AppColors.success : AppColors.error)
        : AppColors.skillPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          enabled: !showFeedback,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Type your answer…',
            filled: true,
            fillColor: showFeedback
                ? (isCorrect
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1))
                : Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.secondary, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
        if (showFeedback && !isCorrect) ...[
          const SizedBox(height: 8),
          Text(
            'Correct answer: $correctAnswer',
            style: const TextStyle(
              color: AppColors.successDark,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (wordBank.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Or tap a word:',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: wordBank.map((word) {
              final selected = controller.text == word;
              return ActionChip(
                label: Text(word),
                backgroundColor: selected
                    ? AppColors.secondary.withValues(alpha: 0.15)
                    : Colors.white,
                side: BorderSide(
                  color: selected ? AppColors.secondary : AppColors.skillPath,
                  width: 2,
                ),
                onPressed: showFeedback ? null : () => _tapChip(word),
              );
            }).toList(),
          ),
        ],
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
