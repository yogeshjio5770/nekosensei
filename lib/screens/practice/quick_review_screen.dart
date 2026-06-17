import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../services/spaced_repetition_service.dart';
import '../../utils/platform_layout.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../widgets/quiz/duolingo_answer_button.dart';
import '../../utils/safe_init.dart';

/// Spaced repetition quick review — faster retention than Duolingo's passive review.
class QuickReviewScreen extends ConsumerStatefulWidget {
  const QuickReviewScreen({super.key});

  @override
  ConsumerState<QuickReviewScreen> createState() => _QuickReviewScreenState();
}

class _QuickReviewScreenState extends ConsumerState<QuickReviewScreen> {
  final _srs = SpacedRepetitionService();
  List<ReviewItem> _items = [];
  int _index = 0;
  int _correct = 0;
  bool _loading = true;
  bool _showAnswer = false;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    safeInitServices(ref, [
      () => ref.read(audioServiceProvider).initialize(),
    ]);
  }

  Future<void> _load() async {
    final items = await _srs.getDueItems(limit: 8);
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _answer(bool correct) async {
    await _srs.recordReview(_items[_index].id, correct);
    if (correct) {
      _correct++;
      await ref.read(audioServiceProvider).playCorrect();
    } else {
      await ref.read(audioServiceProvider).playWrong();
    }

    if (_index < _items.length - 1) {
      setState(() {
        _index++;
        _showAnswer = false;
        _selected = null;
      });
    } else {
      if (mounted) {
        context.pushReplacement('/quiz-result', extra: {
          'score': (_correct / _items.length * 100).round(),
          'correct': _correct,
          'total': _items.length,
          'passed': _correct >= _items.length * 0.6,
          'xp': AppConstants.xpQuickReview,
          'isReview': true,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quick Review')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: PlatformLayout.pagePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NekoMascot(
                    size: 120,
                    mood: MascotMood.happy,
                    showSpeechBubble: 'All caught up! にゃん!',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final item = _items[_index];
    final audio = ref.read(audioServiceProvider);
    final options = _generateOptions(item);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${_index + 1}/${_items.length}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
          child: Padding(
            padding: PlatformLayout.pagePadding(context),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_index + 1) / _items.length,
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 10,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 32),
                NekoMascot(
                  size: 70,
                  mood: MascotMood.thinking,
                  showSpeechBubble: 'What does this mean?',
                ),
                const SizedBox(height: 24),
                Text(
                  item.japanese,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ).animate().scale(curve: Curves.elasticOut),
                const SizedBox(height: 8),
                Text(item.romaji, style: TextStyle(color: AppColors.secondary)),
                const SizedBox(height: 16),
                PronunciationButton(japanese: item.japanese, audio: audio, size: 48),
                const Spacer(),
                if (!_showAnswer)
                  ...options.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DuolingoAnswerButton(
                            number: e.key + 1,
                            label: e.value,
                            state: _selected == e.value
                                ? AnswerButtonState.selected
                                : AnswerButtonState.normal,
                            onTap: () => setState(() => _selected = e.value),
                          ),
                        ),
                      ),
                if (!_showAnswer)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selected != null
                          ? () {
                              setState(() => _showAnswer = true);
                              _answer(_selected == item.english);
                            }
                          : null,
                      child: const Text('CHECK'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _generateOptions(ReviewItem item) {
    final all = _items.map((i) => i.english).toSet().toList();
    all.remove(item.english);
    all.shuffle();
    return [item.english, ...all.take(3)]..shuffle();
  }
}
