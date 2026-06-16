import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import 'pronunciation_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Listen ${widget.index + 1}/${widget.total}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              widget.item.english,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_revealed) ...[
              Text(
                widget.item.japanese,
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ).animate().fadeIn().scale(curve: Curves.elasticOut),
              const SizedBox(height: 8),
              Text(
                widget.item.romaji,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
              ).animate().fadeIn(delay: 100.ms),
            ] else
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Tap 🔊 to listen, then reveal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 24),
            PronunciationButton(
              japanese: widget.item.japanese,
              audio: widget.audio,
              size: 72,
              label: 'Listen',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _listenCount++;
                        widget.audio.speakJapanese(widget.item.japanese);
                      });
                    },
                    child: Text('Replay ($_listenCount)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _listenCount > 0
                        ? () {
                            setState(() => _revealed = true);
                            if (_listenCount >= 1) {
                              Future.delayed(const Duration(milliseconds: 600),
                                  widget.onMastered);
                            }
                          }
                        : null,
                    child: Text(_revealed ? 'Got it!' : 'Reveal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
