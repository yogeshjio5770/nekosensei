import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import 'pronunciation_button.dart';

/// Duolingo-style listen step: hear → reveal → review → user taps CONTINUE.
class ListenRepeatCard extends StatefulWidget {
  const ListenRepeatCard({
    super.key,
    required this.item,
    required this.audio,
    required this.onMastered,
    this.index = 0,
    this.total = 1,
  });

  final ListenItem item;
  final AudioService audio;
  final VoidCallback onMastered;
  final int index;
  final int total;

  @override
  State<ListenRepeatCard> createState() => _ListenRepeatCardState();
}

class _ListenRepeatCardState extends State<ListenRepeatCard> {
  int _listenCount = 0;
  bool _revealed = false;
  bool _readyToContinue = false;

  Future<void> _playAudio({bool slow = false}) async {
    setState(() => _listenCount++);
    if (slow) {
      await widget.audio.speakSlow(widget.item.japanese);
    } else {
      await widget.audio.speakJapanese(widget.item.japanese);
    }
  }

  void _reveal() {
    setState(() {
      _revealed = true;
      _readyToContinue = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Listen & learn  ${widget.index + 1} / ${widget.total}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.skillPath, width: 2),
          ),
          child: Column(
            children: [
              Text(
                'What does this mean?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.item.japanese,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.item.romaji,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              PronunciationButton(
                japanese: widget.item.japanese,
                audio: widget.audio,
                size: 80,
                label: _listenCount == 0 ? 'Tap to listen' : 'Listen again',
              ),
              if (_listenCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Listened $_listenCount time${_listenCount == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 24),
              if (!_revealed) ...[
                OutlinedButton.icon(
                  onPressed: _reveal,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('SHOW ANSWER'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                if (_listenCount == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Step 1: Listen  •  Step 2: Show answer  •  Step 3: Continue',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.item.english,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.95, 0.95),
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _playAudio(),
                        child: const Text('Replay'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _playAudio(slow: true),
                        child: const Text('Slow'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (_readyToContinue) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onMastered,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
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
