import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../common/celebration_overlay.dart';
import '../common/neko_mascot.dart';

/// Full-screen level-up — Duolingo-style but with NekoSensei branding.
class LevelUpOverlay extends StatelessWidget {
  const LevelUpOverlay({
    super.key,
    required this.level,
    required this.onDismiss,
  });

  final int level;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: CelebrationOverlay(
        active: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.secondaryDark],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NekoMascot(
                  size: 120,
                  mood: MascotMood.cheering,
                  showSpeechBubble: 'Level up! すごい!',
                ),
                const SizedBox(height: 20),
                Text(
                  'LEVEL UP!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                ).animate().scale(curve: Curves.elasticOut),
                Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                curve: Curves.elasticOut,
                duration: 600.ms,
              ),
        ),
      ),
    );
  }
}
