import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../data/phrases_repository.dart';
import '../../providers/app_providers.dart';
import '../../services/daily_lesson_service.dart';
import '../../utils/platform_layout.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../utils/safe_init.dart';

/// 5-minute daily boost — learn essential phrases fast (speak + listen + understand).
class DailyBoostScreen extends ConsumerStatefulWidget {
  const DailyBoostScreen({super.key});

  @override
  ConsumerState<DailyBoostScreen> createState() => _DailyBoostScreenState();
}

class _DailyBoostScreenState extends ConsumerState<DailyBoostScreen> {
  int _phase = 0; // 0=intro, 1=phrases, 2=speak prompt, 3=done
  int _phraseIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    safeInitServices(ref, [
      () => ref.read(audioServiceProvider).initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final boost = DailyLessonService().pickDailyBoost(
      user?.completedLessons ?? [],
    );
    final phrases = PhrasesRepository.dailyPhrases.take(5).toList();
    final audio = ref.read(audioServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Boost ⚡')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
          child: SingleChildScrollView(
            padding: PlatformLayout.pagePadding(context),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.2),
                        AppColors.nekoOrange.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.warning, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppConstants.dailyBoostMinutes}-Min Daily Boost',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Speak & understand real Japanese — fast!',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 24),
                const NekoMascot(
                  size: 100,
                  mood: MascotMood.excited,
                  showSpeechBubble: '5 phrases today — you\'ll use these in Japan!',
                ),
                const SizedBox(height: 24),
                if (_phraseIndex < phrases.length) ...[
                  _PhraseCard(
                    phrase: phrases[_phraseIndex],
                    audio: audio,
                    index: _phraseIndex + 1,
                    total: phrases.length,
                  ).animate().fadeIn().scale(curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (_phraseIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _phraseIndex--),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_phraseIndex > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            await audio.speakJapanese(phrases[_phraseIndex].japanese);
                            if (_phraseIndex < phrases.length - 1) {
                              setState(() => _phraseIndex++);
                            } else {
                              setState(() => _phase = 3);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            _phraseIndex < phrases.length - 1
                                ? 'NEXT PHRASE'
                                : 'FINISH BOOST',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (_phase == 3) ...[
                  const Icon(Icons.celebration, size: 64, color: AppColors.success),
                  const SizedBox(height: 16),
                  Text(
                    'Daily Boost Complete!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('+${AppConstants.xpDailyBoost} XP'),
                  const SizedBox(height: 24),
                  if (boost.lesson != null)
                    ElevatedButton(
                      onPressed: () =>
                          context.push('/lesson/${boost.lesson!.id}'),
                      child: Text('Continue: ${boost.lesson!.title}'),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Back to Home'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({
    required this.phrase,
    required this.audio,
    required this.index,
    required this.total,
  });

  final DailyPhrase phrase;
  final dynamic audio;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('$index / $total', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(
              phrase.japanese,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              phrase.romaji,
              style: TextStyle(color: AppColors.secondary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              phrase.english,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              phrase.context,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PronunciationButton(
              japanese: phrase.japanese,
              audio: audio,
              size: 64,
              label: 'Tap to hear',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Say it out loud 3 times to remember!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
