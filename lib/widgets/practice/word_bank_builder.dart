import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/quiz_answer_checker.dart';
import '../../config/constants.dart';
import '../../services/haptic_service.dart';
import '../../utils/japanese_tokens.dart';

/// Duolingo-style: tap word tiles to build a Japanese sentence.
class WordBankBuilder extends StatefulWidget {
  const WordBankBuilder({
    super.key,
    required this.wordBank,
    required this.correctAnswer,
    required this.onChecked,
    this.enabled = true,
  });

  final List<String> wordBank;
  final String correctAnswer;
  final void Function(bool correct) onChecked;
  final bool enabled;

  @override
  State<WordBankBuilder> createState() => _WordBankBuilderState();
}

class _WordBankBuilderState extends State<WordBankBuilder> {
  final List<String> _selected = [];
  final List<int> _pickedIndices = [];
  bool? _checked;
  bool _correct = false;

  String get _built => JapaneseTokens.joinTokens(_selected);

  String get _normalizedCorrect =>
      widget.correctAnswer.replaceAll(RegExp(r'[。、！？!?.\s]'), '');

  void _tapBankWord(int index) {
    if (!widget.enabled || _checked != null) return;
    HapticService.selection();
    setState(() {
      _selected.add(widget.wordBank[index]);
      _pickedIndices.add(index);
    });
  }

  void _removeLast() {
    if (!widget.enabled || _checked != null || _selected.isEmpty) return;
    HapticService.selection();
    setState(() {
      _selected.removeLast();
      _pickedIndices.removeLast();
    });
  }

  void _clear() {
    if (!widget.enabled || _checked != null) return;
    setState(() {
      _selected.clear();
      _pickedIndices.clear();
    });
  }

  void _check() {
    if (_selected.isEmpty || _checked != null) return;
    final ok = _built == _normalizedCorrect ||
        QuizAnswerChecker.isCorrect(_built, _normalizedCorrect);
    setState(() {
      _checked = true;
      _correct = ok;
    });
    if (ok) {
      HapticService.correctAnswer();
    } else {
      HapticService.wrongAnswer();
    }
    widget.onChecked(ok);
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final borderColor = _checked == null
        ? AppColors.skillPath
        : (_correct ? AppColors.success : AppColors.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _checked != null
                ? (_correct
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.error.withValues(alpha: 0.08))
                : surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: _selected.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below to build your answer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selected
                      .map(
                        (w) => Chip(
                          label: Text(w, style: const TextStyle(fontSize: 16)),
                          backgroundColor:
                              AppColors.secondary.withValues(alpha: 0.12),
                          side: const BorderSide(color: AppColors.secondary),
                        ),
                      )
                      .toList(),
                ),
        ),
        if (_checked != null && !_correct) ...[
          const SizedBox(height: 8),
          Text(
            'Correct: ${widget.correctAnswer}',
            style: const TextStyle(
              color: AppColors.successDark,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (_checked == null && _selected.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: _removeLast, child: const Text('Undo')),
              TextButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: widget.wordBank.asMap().entries.map((entry) {
            final used = _pickedIndices.contains(entry.key);
            return ActionChip(
              label: Text(entry.value, style: const TextStyle(fontSize: 15)),
              backgroundColor: used
                  ? AppColors.skillPath.withValues(alpha: 0.5)
                  : Colors.white,
              side: BorderSide(
                color: used ? AppColors.skillLocked : AppColors.skillPath,
                width: 2,
              ),
              onPressed:
                  used || _checked != null ? null : () => _tapBankWord(entry.key),
            );
          }).toList(),
        ).animate().fadeIn(duration: 300.ms),
        if (_checked == null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selected.isEmpty ? null : _check,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: AppColors.skillLocked,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('CHECK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }
}
