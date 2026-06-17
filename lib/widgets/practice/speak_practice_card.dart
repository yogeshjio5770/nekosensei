import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import '../../services/haptic_service.dart';
import '../../services/speech_service.dart';
import '../common/neko_mascot.dart';
import 'pronunciation_button.dart';

/// Speak step: listen first → optional reveal → speak → feedback stays until CONTINUE.
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
  bool _showText = false;
  int _listenCount = 0;
  bool _speechUnavailable = false;

  bool get _canContinue => true;

  Future<void> _hearPhrase() async {
    setState(() => _listenCount++);
    await widget.audio.speakJapanese(widget.drill.japanese);
  }

  Future<void> _startListening() async {
    final ready = widget.speech.isAvailable || await widget.speech.initialize();
    if (!ready) {
      if (!mounted) return;
      setState(() {
        _speechUnavailable = true;
        _listening = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition is not available here. You can keep listening and continue to the quiz.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _listening = true;
      _spoken = '';
      _passed = null;
    });

    final started = await widget.speech.listen(
      onResult: (text) => setState(() => _spoken = text),
      onListening: (isListening) {
        if (!mounted) return;
        setState(() => _listening = isListening);
      },
    );
    if (!started && mounted) {
      setState(() {
        _speechUnavailable = true;
        _listening = false;
      });
    }
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
      _showText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Speak practice  ${widget.index + 1} / ${widget.total}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
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
              ? 'Sugoi! Perfect! にゃん!'
              : _passed == false
                  ? 'Listen again, then retry!'
                  : _listening
                      ? 'I\'m listening...'
                      : 'Repeat after me!',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.skillPath, width: 2),
          ),
          child: Column(
            children: [
              Text(
                'Listen first, then repeat in Japanese if you want:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textSecondaryColor,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.drill.english,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_showText || _listenCount >= 2 || _speechUnavailable) ...[
                Text(
                  widget.drill.japanese,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  widget.drill.romaji,
                  style: TextStyle(color: AppColors.secondary, fontSize: 16),
                ),
              ] else ...[
                TextButton.icon(
                  onPressed: () => setState(() => _showText = true),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Show phrase'),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _hearPhrase,
                    icon: const Icon(Icons.volume_up),
                    label: Text(_listenCount == 0 ? 'Listen' : 'Replay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await widget.audio.speakSlow(widget.drill.japanese);
                    },
                    child: const Text('Slow'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Replay the audio as many times as you need before continuing.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textSecondaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_spoken.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.skillPath, width: 2),
            ),
            child: Text('You said: $_spoken', style: TextStyle(color: textColor)),
          ).animate().fadeIn(),
        if (_passed != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_passed! ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _passed! ? AppColors.success : AppColors.error,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _passed! ? 'Great job!' : 'Not quite — try again',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _passed! ? AppColors.successDark : AppColors.error,
                  ),
                ),
                if (!_passed!) ...[
                  const SizedBox(height: 8),
                  Text('Correct: ${widget.drill.japanese} (${widget.drill.romaji})', style: TextStyle(color: textColor)),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (!_speechUnavailable)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _listening ? _stopAndCheck : _startListening,
              icon: Icon(_listening ? Icons.stop : Icons.mic),
              label: Text(_listening ? 'STOP & CHECK' : 'TRY SPEAKING'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _listening ? AppColors.error : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: Text(
              'Voice input is optional here. This device/browser does not support it, so you can keep listening and move on.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        if (_canContinue) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onComplete(_passed ?? false),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _passed == null
                    ? 'CONTINUE'
                    : (_passed! ? 'CONTINUE' : 'SKIP & CONTINUE'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
