import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import '../../services/haptic_service.dart';
import '../../services/speech_service.dart';
import '../common/neko_mascot.dart';
import 'pronunciation_button.dart';

class SpeakPracticeCard extends StatefulWidget {
  const SpeakPracticeCard({
    super.key,
    required this.drill,
    required this.audio,
    required this.speech,
    required this.onComplete,
    this.index = 0,
    this.total = 1,
  });

  final SpeakDrill drill;
  final AudioService audio;
  final SpeechService speech;
  final void Function(bool success) onComplete;
  final int index;
  final int total;

  @override
  State<SpeakPracticeCard> createState() => _SpeakPracticeCardState();
}

class _SpeakPracticeCardState extends State<SpeakPracticeCard> {
  bool _listening = false;
  String _spoken = '';
  bool? _passed;

  Future<void> _startListening() async {
    setState(() {
      _listening = true;
      _spoken = '';
      _passed = null;
    });

    await widget.speech.listen(
      onResult: (text) => setState(() => _spoken = text),
      onListening: (_) {},
    );
  }

  Future<void> _stopAndCheck() async {
    await widget.speech.stop();
    final passed = SpeechService.matchesExpected(
      _spoken,
      widget.drill.japanese,
      romaji: widget.drill.romaji,
    );

    if (passed) {
      await HapticService.correctAnswer();
      await widget.audio.playCorrect();
    } else {
      await HapticService.wrongAnswer();
      await widget.audio.playWrong();
    }

    setState(() {
      _listening = false;
      _passed = passed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Speak ${widget.index + 1}/${widget.total}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            NekoMascot(
              size: 70,
              mood: _passed == true
                  ? MascotMood.excited
                  : _passed == false
                      ? MascotMood.sad
                      : _listening
                          ? MascotMood.thinking
                          : MascotMood.happy,
              showSpeechBubble: _passed == true
                  ? 'Perfect! にゃん!'
                  : _passed == false
                      ? 'Try again — listen first!'
                      : _listening
                          ? 'I\'m listening...'
                          : 'Repeat after me!',
            ),
            const SizedBox(height: 16),
            Text(
              widget.drill.english,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.drill.japanese,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.drill.romaji,
              style: TextStyle(color: AppColors.secondary, fontSize: 16),
            ),
            const SizedBox(height: 16),
            PronunciationButton(
              japanese: widget.drill.japanese,
              audio: widget.audio,
              label: 'Hear native pronunciation',
            ),
            const SizedBox(height: 20),
            if (_spoken.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.skillPath, width: 2),
                ),
                child: Text('You said: $_spoken'),
              ).animate().fadeIn(),
            const SizedBox(height: 16),
            if (_passed != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_passed! ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _passed!
                      ? 'Great pronunciation!'
                      : 'Hint: ${widget.drill.hint}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _passed! ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _listening ? _stopAndCheck : _startListening,
                icon: Icon(_listening ? Icons.stop : Icons.mic),
                label: Text(_listening ? 'STOP & CHECK' : 'TAP TO SPEAK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _listening ? AppColors.error : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            if (_passed != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => widget.onComplete(_passed!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('CONTINUE'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
