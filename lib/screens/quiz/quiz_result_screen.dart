import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../services/haptic_service.dart';
import '../../utils/platform_layout.dart';
import '../../widgets/celebrations/level_up_overlay.dart';
import '../../widgets/common/celebration_overlay.dart';
import '../../widgets/common/neko_mascot.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  const QuizResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  bool _showLevelUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final passed = widget.extra['passed'] as bool;
      if (passed) {
        await HapticService.celebration();
        await ref.read(audioServiceProvider).playSuccess();
        if (widget.extra['leveledUp'] == true) {
          setState(() => _showLevelUp = true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.extra['score'] as int;
    final correct = widget.extra['correct'] as int;
    final total = widget.extra['total'] as int;
    final passed = widget.extra['passed'] as bool;
    final xp = widget.extra['xp'] as int;
    final newLevel = widget.extra['newLevel'] as int? ?? 1;

    return Stack(
      children: [
        CelebrationOverlay(
          active: passed,
          child: Scaffold(
            backgroundColor: passed
                ? AppColors.success.withValues(alpha: 0.08)
                : AppColors.lightBackground,
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Padding(
                    padding: PlatformLayout.pagePadding(context),
                    child: Column(
                      children: [
                        const Spacer(),
                        Animate(
                          child: NekoMascot(
                            size: 140,
                            mood: passed ? MascotMood.cheering : MascotMood.sad,
                            showSpeechBubble: passed
                                ? 'Amazing work! にゃあ〜!'
                                : 'Don\'t give up! Practice makes perfect!',
                          ),
                        )
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: passed ? const Offset(0.5, 0.5) : const Offset(1, 1),
                              curve: Curves.elasticOut,
                            ),
                        const SizedBox(height: 24),
                        Text(
                          passed ? 'Lesson Complete!' : 'Keep Practicing!',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color:
                                        passed ? AppColors.success : AppColors.warning,
                                  ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 16),
                        Text(
                          '$score%',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 64,
                              ),
                        ).animate().scale(delay: 300.ms, curve: Curves.elasticOut),
                        Text('$correct / $total correct')
                            .animate()
                            .fadeIn(delay: 400.ms),
                        if (passed) ...[
                          const SizedBox(height: 24),
                          XpPopAnimation(xp: xp)
                              .animate()
                              .fadeIn(delay: 500.ms)
                              .slideY(begin: 0.5),
                        ],
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: passed
                                  ? AppColors.success
                                  : AppColors.secondary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                        if (!passed) ...[
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_showLevelUp)
          LevelUpOverlay(
            level: newLevel,
            onDismiss: () => setState(() => _showLevelUp = false),
          ),
      ],
    );
  }
}
