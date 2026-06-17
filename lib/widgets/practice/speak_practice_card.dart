import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../services/audio_service.dart';
import '../../services/daily_lesson_service.dart';
import '../../services/haptic_service.dart';
import '../../services/hugging_face_service.dart';
import '../../providers/app_providers.dart';
import '../../services/speech_service.dart';
import '../common/neko_mascot.dart';
import 'pronunciation_button.dart';

/// Speak step: listen first → optional reveal → speak → feedback stays until CONTINUE.
class SpeakPracticeCard extends ConsumerStatefulWidget {
  const SpeakPracticeCard({
    super.key,
    required this.drill,
    required this.audio,
    required this.onComplete,
    this.index = 0,
    this.total = 1,
  });

  final SpeakDrill drill;
  final AudioService audio;
  final void Function(bool success) onComplete;
  final int index;
  final int total;

  @override
  ConsumerState<SpeakPracticeCard> createState() => _SpeakPracticeCardState();
}

class _SpeakPracticeCardState extends ConsumerState<SpeakPracticeCard> {
  bool _listening = false;
  String _spoken = '';
  bool? _passed;
  bool _showText = false;
  int _listenCount = 0;
  bool _speechUnavailable = false;
  bool _initializing = false;
  bool _isEvaluating = false;

  bool get _canContinue => true;

  Future<void> _hearPhrase() async {
    setState(() => _listenCount++);
    await widget.audio.speakJapanese(widget.drill.japanese);
  }

  Future<void> _startListening() async {
    final speech = ref.read(speechServiceProvider);
    
    if (_initializing || _isEvaluating) return;
    
    setState(() {
      _initializing = true;
      _speechUnavailable = false;
      _spoken = '';
      _passed = null;
    });

    try {
      final ready = speech.isAvailable || await speech.initialize();
      if (!ready) {
        if (!mounted) return;
        setState(() {
          _speechUnavailable = true;
          _listening = false;
          _initializing = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _listening = true;
        _initializing = false;
      });

      final started = await speech.listen(
        onResult: (t) {
          if (mounted) {
            setState(() => _spoken = t);
          }
        },
        onListening: (isListening) {
          if (!mounted) return;
          final wasListening = _listening;
          setState(() => _listening = isListening);
          // If the SDK stopped listening on its own (e.g. detected silence)
          // and we have captured spoken words, check them automatically!
          if (wasListening && !isListening && _spoken.isNotEmpty && _passed == null) {
            _stopAndCheck();
          }
        },
      );

      if (!started && mounted) {
        setState(() {
          _speechUnavailable = true;
          _listening = false;
        });
      }
    } catch (e) {
      print('[SpeakCard] Error: $e');
      if (!mounted) return;
      setState(() {
        _speechUnavailable = true;
        _listening = false;
        _initializing = false;
      });
    }
  }

  Future<void> _stopAndCheck() async {
    if (_isEvaluating || _passed != null) return;
    
    setState(() {
      _isEvaluating = true;
    });

    final speech = ref.read(speechServiceProvider);
    await speech.stop();
    
    if (mounted) {
      setState(() {
        _listening = false;
      });
    }

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

    if (mounted) {
      setState(() {
        _passed = passed;
        _showText = true;
        _isEvaluating = false;
      });
    }
  }

  Widget _buildMicButton() {
    if (_passed == true) {
      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 40, color: Colors.white),
      ).animate().scale(duration: 400.ms, curve: Curves.elasticOut);
    }
    
    final isActive = _listening;
    final isInitializing = _initializing;
    
    Color buttonColor = AppColors.primary;
    if (isActive) buttonColor = AppColors.error;
    if (_passed == false) buttonColor = AppColors.accentDark;
    
    Widget micIcon = Icon(
      _passed == false ? Icons.refresh : (isActive ? Icons.stop : Icons.mic),
      size: 36,
      color: Colors.white,
    );
    
    if (isInitializing) {
      micIcon = const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white,
        ),
      );
    }

    final buttonBody = GestureDetector(
      onTap: () {
        if (_passed == false) {
          // Retry
          setState(() {
            _passed = null;
            _spoken = '';
          });
          _startListening();
        } else if (isActive) {
          _stopAndCheck();
        } else {
          _startListening();
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 4,
            )
          ],
        ),
        child: Center(child: micIcon),
      ),
    );

    if (isActive) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat())
           .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.3, 1.3), duration: 1200.ms, curve: Curves.easeOut)
           .fadeOut(duration: 1200.ms),
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat())
           .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1200.ms, delay: 400.ms, curve: Curves.easeOut)
           .fadeOut(duration: 1200.ms),
          buttonBody,
        ],
      );
    }
    
    return buttonBody;
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
        Animate(
          target: _passed == false ? 1.0 : 0.0,
          effects: [
            ShakeEffect(duration: 500.ms, hz: 6, curve: Curves.easeInOut),
          ],
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _passed == true
                    ? AppColors.success
                    : _passed == false
                        ? AppColors.error
                        : AppColors.skillPath,
                width: 2.5,
              ),
              boxShadow: [
                if (_passed == true)
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                if (_passed == false)
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Listen first, then repeat in Japanese:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.drill.english,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_showText || _listenCount >= 2 || _speechUnavailable) ...[
                  Text(
                    widget.drill.japanese,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ).animate().scale(duration: 200.ms, curve: Curves.easeOut),
                  const SizedBox(height: 4),
                  Text(
                    widget.drill.romaji,
                    style: const TextStyle(color: AppColors.secondary, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ] else ...[
                  TextButton.icon(
                    onPressed: () => setState(() => _showText = true),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Show phrase', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _hearPhrase,
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      label: Text(_listenCount == 0 ? 'Listen' : 'Replay', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 14),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await widget.audio.speakSlow(widget.drill.japanese);
                      },
                      icon: const Icon(Icons.slow_motion_video),
                      label: const Text('Slow', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Real-time speech response feedback box
        if (_spoken.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text(
                  'WHAT WE HEARD:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: textSecondaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: _passed == true
                        ? AppColors.successLight
                        : _passed == false
                            ? AppColors.errorLight
                            : surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _passed == true
                          ? AppColors.success
                          : _passed == false
                              ? AppColors.error
                              : AppColors.primary.withValues(alpha: 0.3),
                      width: 2.5,
                    ),
                  ),
                  child: Text(
                    _spoken,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _passed == true
                          ? AppColors.successDark
                          : _passed == false
                              ? AppColors.errorDark
                              : textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate(key: ValueKey(_spoken)).fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0.0),
              ],
            ),
          ),

        if (_passed != null) ...[
          const SizedBox(height: 20),
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
                  _passed! ? 'Great job! 🐾' : 'Not quite — try again!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _passed! ? AppColors.successDark : AppColors.error,
                  ),
                ),
                if (!_passed!) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Try matching: ${widget.drill.japanese} (${widget.drill.romaji})', 
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ).animate().slideY(begin: 0.2, end: 0.0, curve: Curves.easeOutBack),
        ],

        const Spacer(),

        if (!_speechUnavailable)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: _buildMicButton()),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: Text(
              'Voice input is optional here. Your browser/device doesn\'t support speech recognition, but you can continue the lesson!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

        if (_canContinue) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onComplete(_passed ?? false),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
              child: Text(
                _passed == null
                    ? 'CONTINUE'
                    : (_passed! ? 'CONTINUE' : 'SKIP & CONTINUE'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 1.1),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
