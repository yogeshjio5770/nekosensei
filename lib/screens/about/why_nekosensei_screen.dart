import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../widgets/common/neko_mascot.dart';

class WhyNekoSenseiScreen extends StatelessWidget {
  const WhyNekoSenseiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const comparisons = [
      (
        'Speaking practice',
        'Limited / paid',
        'Every lesson — free',
        Icons.mic,
      ),
      (
        'Japanese-only path',
        'One of 40+ languages',
        'Built for JLPT',
        Icons.route,
      ),
      (
        'Certificates',
        'Streak badges',
        'N5 / N4 / N3 PDF',
        Icons.workspace_premium,
      ),
      (
        'AI tutor',
        'Duolingo Max (paid)',
        'NekoSensei included',
        Icons.pets,
      ),
      (
        'Lesson flow',
        'Mostly tap quizzes',
        'Learn→Listen→Speak→Quiz',
        Icons.school,
      ),
      (
        'Romaji for beginners',
        'Hidden early',
        'Always visible',
        Icons.translate,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Why NekoSensei?')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const NekoMascot(
            size: 100,
            mood: MascotMood.cheering,
            showSpeechBubble: 'We beat Duolingo at Japanese! にゃあ!',
          ).animate().fadeIn().scale(curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'Duolingo teaches you to tap.\nNekoSensei teaches you to speak.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...comparisons.asMap().entries.map((entry) {
            final c = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                      child: Icon(c.$4, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Duolingo: ${c.$2}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.lightTextSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'NekoSensei: ${c.$3}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate(delay: (entry.key * 60).ms)
                .fadeIn()
                .slideX(begin: 0.05);
          }),
        ],
      ),
    );
  }
}
