import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import '../../services/haptic_service.dart';
import '../../utils/quiz_answer_checker.dart';
import 'word_bank_builder.dart';

/// Duolingo-style listen drills — translate, listen & pick, word bank, reveal.
class ListenExerciseCard extends StatefulWidget {
  const ListenExerciseCard({
    super.key,
    required this.exercise,
    required this.audio,
    required this.onComplete,
    this.index = 0,
    this.total = 1,
  });

  final ListenExercise exercise;
  final AudioService audio;
  final VoidCallback onComplete;
  final int index;
  final int total;

  @override
  State<ListenExerciseCard> createState() => _ListenExerciseCardState();
}

class _ListenExerciseCardState extends State<ListenExerciseCard> {
  int _listenCount = 0;
  bool _playing = false;
  String? _selectedOption;
  bool? _checked;
  bool _readyToContinue = false;

  Future<void> _play({bool slow = false}) async {
    setState(() => _playing = true);
    setState(() => _listenCount++);
    if (slow) {
      await widget.audio.speakSlow(widget.exercise.japanese);
    } else {
      await widget.audio.speakJapanese(widget.exercise.japanese);
    }
    if (mounted) setState(() => _playing = false);
  }

  void _selectOption(String option) {
    if (_checked != null) return;
    if (widget.exercise.type == ListenExerciseType.listenSelect && _listenCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listen first — tap the speaker! 🔊')),
      );
      return;
    }
    HapticService.selection();
    setState(() => _selectedOption = option);
  }

  void _checkOption() {
    if (_selectedOption == null || _checked != null) return;
    final ok = QuizAnswerChecker.isCorrect(_selectedOption!, widget.exercise.correctOption);
    setState(() {
      _checked = true;
      _readyToContinue = true;
    });
    if (ok) {
      HapticService.correctAnswer();
      widget.audio.playCorrect();
    } else {
      HapticService.wrongAnswer();
      widget.audio.playWrong();
    }
  }

  void _onWordBankChecked(bool correct) {
    setState(() {
      _checked = true;
      _readyToContinue = true;
    });
    if (correct) {
      widget.audio.playCorrect();
    } else {
      widget.audio.playWrong();
    }
  }

  void _revealClassic() {
    if (_listenCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listen first — tap the speaker! 🔊')),
      );
      return;
    }
    setState(() {
      _checked = true;
      _readyToContinue = true;
    });
  }

  String get _typeLabel => switch (widget.exercise.type) {
        ListenExerciseType.translateBuild => 'Translate to Japanese',
        ListenExerciseType.listenSelect => 'What did you hear?',
        ListenExerciseType.readSelect => 'Pick the correct Japanese',
        ListenExerciseType.listenReveal => 'Listen & learn',
      };

  bool get _showSpeaker =>
      widget.exercise.type != ListenExerciseType.readSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Listen  ${widget.index + 1} / ${widget.total}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _typeLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _PromptCard(
          exercise: widget.exercise,
          listenCount: _listenCount,
          playing: _playing,
          showSpeaker: _showSpeaker,
          showJapanese: widget.exercise.type == ListenExerciseType.readSelect ||
              (_checked == true && widget.exercise.type == ListenExerciseType.listenReveal),
          onPlay: () => _play(),
          onPlaySlow: () => _play(slow: true),
        ),
        const SizedBox(height: 20),
        ...switch (widget.exercise.type) {
          ListenExerciseType.translateBuild => [
              WordBankBuilder(
                wordBank: widget.exercise.wordBank,
                correctAnswer: widget.exercise.japanese,
                onChecked: _onWordBankChecked,
                enabled: _checked == null,
              ),
            ],
          ListenExerciseType.listenSelect || ListenExerciseType.readSelect => [
              _OptionGrid(
                options: widget.exercise.options,
                selected: _selectedOption,
                checked: _checked,
                correct: widget.exercise.correctOption,
                onSelect: _selectOption,
              ),
              if (_checked == null && _selectedOption != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkOption,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('CHECK', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ListenExerciseType.listenReveal => [
              if (_checked != true)
                OutlinedButton.icon(
                  onPressed: _revealClassic,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('REVEAL ANSWER'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                )
              else
                _AnswerReveal(
                  exercise: widget.exercise,
                  onReplay: () => _play(),
                  onReplaySlow: () => _play(slow: true),
                ).animate().fadeIn(duration: 400.ms),
            ],
        },
        if (_readyToContinue) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.exercise,
    required this.listenCount,
    required this.playing,
    required this.showSpeaker,
    required this.showJapanese,
    required this.onPlay,
    required this.onPlaySlow,
  });

  final ListenExercise exercise;
  final int listenCount;
  final bool playing;
  final bool showSpeaker;
  final bool showJapanese;
  final VoidCallback onPlay;
  final VoidCallback onPlaySlow;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.skillPath, width: 2),
      ),
      child: Column(
        children: [
          if (exercise.type == ListenExerciseType.translateBuild ||
              exercise.type == ListenExerciseType.readSelect) ...[
            Text(
              exercise.english,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (exercise.type == ListenExerciseType.translateBuild)
              Text(
                'Tap words below to build the Japanese sentence',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
          ] else if (showJapanese) ...[
            Text(
              exercise.japanese,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(exercise.romaji, style: TextStyle(color: AppColors.secondary)),
            Text(exercise.english),
          ] else ...[
            Text(
              exercise.type == ListenExerciseType.listenSelect ? '???' : exercise.english,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: exercise.type == ListenExerciseType.listenSelect
                        ? AppColors.lightTextSecondary
                        : null,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showSpeaker) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: playing ? null : onPlay,
              onLongPress: playing ? null : onPlaySlow,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: playing
                        ? [AppColors.accent, AppColors.nekoOrange]
                        : [AppColors.secondary, AppColors.secondaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                      blurRadius: playing ? 14 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  playing ? Icons.graphic_eq : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              listenCount == 0 ? 'Tap to listen' : 'Replay ($listenCount)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (listenCount == 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Hold speaker for slow audio',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _OptionGrid extends StatelessWidget {
  const _OptionGrid({
    required this.options,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.onSelect,
  });

  final List<String> options;
  final String? selected;
  final bool? checked;
  final String correct;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isSelected = selected == opt;
        final isCorrect = QuizAnswerChecker.isCorrect(opt, correct);
        Color? bg;
        var border = AppColors.skillPath;
        if (checked != null && isSelected) {
          bg = isCorrect
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.error.withValues(alpha: 0.15);
          border = isCorrect ? AppColors.success : AppColors.error;
        } else if (isSelected) {
          bg = AppColors.secondary.withValues(alpha: 0.12);
          border = AppColors.secondary;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: bg ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: checked != null ? null : () => onSelect(opt),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border, width: 2),
                ),
                child: Text(
                  opt,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AnswerReveal extends StatelessWidget {
  const _AnswerReveal({
    required this.exercise,
    required this.onReplay,
    required this.onReplaySlow,
  });

  final ListenExercise exercise;
  final VoidCallback onReplay;
  final VoidCallback onReplaySlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success, width: 2),
      ),
      child: Column(
        children: [
          Text(
            exercise.japanese,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Text(exercise.romaji, style: TextStyle(color: AppColors.secondary)),
          Text(exercise.english),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: onReplay, child: const Text('Replay')),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(onPressed: onReplaySlow, child: const Text('Slow')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
