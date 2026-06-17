import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';
import '../../services/daily_lesson_service.dart';
import '../../widgets/common/lesson_progress_bar.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/lesson_step_indicator.dart';
import '../../widgets/practice/listen_repeat_card.dart';
import '../../widgets/practice/speak_practice_card.dart';
import '../../utils/platform_layout.dart';
import '../../utils/safe_init.dart';
import 'lesson_learn_step.dart';

/// 4-step lesson: Learn → Listen → Speak → Quiz
/// This is NekoSensei's edge over Duolingo for Japanese — integrated speaking from day 1.
class LessonFlowScreen extends ConsumerStatefulWidget {
  const LessonFlowScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonFlowScreen> createState() => _LessonFlowScreenState();
}

class _LessonFlowScreenState extends ConsumerState<LessonFlowScreen> {
  LessonStep _step = LessonStep.learn;
  int _listenIndex = 0;
  int _speakIndex = 0;

  late final DailyLessonService _dailyService;

  @override
  void initState() {
    super.initState();
    _dailyService = DailyLessonService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    useLessonServices(ref);
  }

  LessonStep get _nextStep => switch (_step) {
        LessonStep.learn => LessonStep.listen,
        LessonStep.listen => LessonStep.speak,
        LessonStep.speak => LessonStep.quiz,
        LessonStep.quiz => LessonStep.quiz,
      };

  double get _progress => switch (_step) {
        LessonStep.learn => 0.2,
        LessonStep.listen => 0.45,
        LessonStep.speak => 0.75,
        LessonStep.quiz => 1.0,
      };

  void _goNext() {
    if (_step == LessonStep.quiz) {
      context.push('/quiz/${widget.lessonId}');
      return;
    }
    setState(() => _step = _nextStep);
  }

  @override
  Widget build(BuildContext context) {
    final lesson = CourseRepository.getLesson(widget.lessonId);
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final listenItems = _dailyService.getListenItemsForLesson(widget.lessonId);
    final speakDrills = _dailyService.getSpeakDrillsForLesson(widget.lessonId);
    final audio = ref.read(audioServiceProvider);
    final speech = ref.read(speechServiceProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: LessonProgressBar(progress: _progress),
        titleSpacing: 8,
      ),
      body: PlatformLayout.adaptiveScaffold(
        context: context,
        body: Column(
        children: [
          LessonStepIndicator(current: _step),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                key: ValueKey('${_step}_$_listenIndex$_speakIndex'),
                padding: PlatformLayout.pagePadding(context),
                child: _buildStepContent(
                  lesson,
                  listenItems,
                  speakDrills,
                  audio,
                  speech,
                ),
              ),
            ),
          ),
          if (_step == LessonStep.learn)
            _BottomBar(
              label: 'START LISTENING',
              color: AppColors.secondary,
              onPressed: _goNext,
            ),
        ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
    LessonModel lesson,
    List<ListenItem> listenItems,
    List<SpeakDrill> speakDrills,
    dynamic audio,
    dynamic speech,
  ) {
    switch (_step) {
      case LessonStep.learn:
        return Column(
          children: [
            NekoMascot(
              size: 90,
              mood: MascotMood.happy,
              showSpeechBubble: 'Let\'s learn together! 一緒に勉強しよう!',
            )
                .animate()
                .fadeIn()
                .scale(curve: Curves.elasticOut),
            const SizedBox(height: 16),
            LessonLearnStep(lesson: lesson, audio: audio),
          ],
        );
      case LessonStep.listen:
        if (listenItems.isEmpty) {
          return _EmptyStep(
            message: 'No listen items — skipping to speak!',
            onContinue: _goNext,
          );
        }
        if (_listenIndex >= listenItems.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _step = LessonStep.speak;
              _listenIndex = 0;
            });
          });
          return const SizedBox.shrink();
        }
        return ListenRepeatCard(
          item: listenItems[_listenIndex],
          audio: audio,
          index: _listenIndex,
          total: listenItems.length,
          onMastered: () {
            if (_listenIndex < listenItems.length - 1) {
              setState(() => _listenIndex++);
            } else {
              setState(() {
                _step = LessonStep.speak;
                _listenIndex = 0;
              });
            }
          },
        );
      case LessonStep.speak:
        if (speakDrills.isEmpty) {
          return _EmptyStep(
            message: 'Ready for the quiz!',
            onContinue: () => context.push('/quiz/${widget.lessonId}'),
          );
        }
        if (_speakIndex >= speakDrills.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _step = LessonStep.quiz);
          });
          return const SizedBox.shrink();
        }
        return SpeakPracticeCard(
          drill: speakDrills[_speakIndex],
          audio: audio,
          speech: speech,
          index: _speakIndex,
          total: speakDrills.length,
          onComplete: (_) {
            if (_speakIndex < speakDrills.length - 1) {
              setState(() => _speakIndex++);
            } else {
              setState(() => _step = LessonStep.quiz);
            }
          },
        );
      case LessonStep.quiz:
        return _QuizReadyCard(
          lessonTitle: lesson.title,
          onStartQuiz: _goNext,
        );
    }
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: AppColors.skillPath, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStep extends StatelessWidget {
  const _EmptyStep({required this.message, required this.onContinue});

  final String message;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Text(message, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: onContinue, child: const Text('CONTINUE')),
      ],
    );
  }
}

class _QuizReadyCard extends StatelessWidget {
  const _QuizReadyCard({
    required this.lessonTitle,
    required this.onStartQuiz,
  });

  final String lessonTitle;
  final VoidCallback onStartQuiz;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 52,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Teaching complete',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You finished the learn, listen, and speak steps for "$lessonTitle". Start the quiz when you are ready.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onStartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'START QUIZ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
