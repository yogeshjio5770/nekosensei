import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';
import '../../services/haptic_service.dart';
import '../../widgets/common/lesson_progress_bar.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../widgets/quiz/duolingo_answer_button.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late QuizModel _quiz;
  int _currentIndex = 0;
  final Map<String, String> _answers = {};
  String? _selectedAnswer;
  bool _showFeedback = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _quiz = CourseRepository.getQuizForLesson(widget.lessonId);
  }

  QuizQuestion get _currentQuestion => _quiz.questions[_currentIndex];

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) return;
    final correct = _selectedAnswer!.trim().toLowerCase() ==
        _currentQuestion.correctAnswer.trim().toLowerCase();

    if (correct) {
      await HapticService.correctAnswer();
      await ref.read(audioServiceProvider).playCorrect();
    } else {
      await HapticService.wrongAnswer();
      await ref.read(audioServiceProvider).playWrong();
    }

    setState(() {
      _answers[_currentQuestion.id] = _selectedAnswer!;
      _showFeedback = true;
      _isCorrect = correct;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
        _isCorrect = null;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    var correct = 0;
    for (final q in _quiz.questions) {
      if (_answers[q.id]?.trim().toLowerCase() ==
          q.correctAnswer.trim().toLowerCase()) {
        correct++;
      }
    }

    final score = (correct / _quiz.questions.length * 100).round();
    final passed = score >= _quiz.passingScore;
    var xp = AppConstants.xpLessonComplete;
    if (score == 100) xp += AppConstants.xpQuizPerfect;

    final lesson = CourseRepository.getLesson(widget.lessonId);
    final user = ref.read(currentUserProvider).value;

    if (user != null && passed && lesson != null) {
      if (user.uid == 'demo_user') {
        final updated = user.copyWith(
          xpPoints: user.xpPoints + xp,
          completedLessons: [...user.completedLessons, widget.lessonId],
          dailyStreak: user.dailyStreak > 0 ? user.dailyStreak : 1,
        );
        ref.read(demoUserProvider.notifier).state = updated;
      } else {
        try {
          await ref.read(progressServiceProvider).completeLesson(
                userId: user.uid,
                lessonId: widget.lessonId,
                moduleId: lesson.moduleId,
                quizScore: score,
                xpEarned: xp,
              );
        } catch (_) {}
      }
      ref.invalidate(currentUserProvider);
    }

    final leveledUp = user != null &&
        passed &&
        _levelFromXp(user.xpPoints + (passed ? xp : 0)) > user.levelFromXp;

    if (mounted) {
      context.pushReplacement('/quiz-result', extra: {
        'score': score,
        'correct': correct,
        'total': _quiz.questions.length,
        'passed': passed,
        'xp': xp,
        'leveledUp': leveledUp,
        'newLevel': user != null
            ? _levelFromXp(user.xpPoints + (passed ? xp : 0))
            : 1,
      });
    }
  }

  int _levelFromXp(int xp) {
    for (var i = AppConstants.levelXpThresholds.length - 1; i >= 0; i--) {
      if (xp >= AppConstants.levelXpThresholds[i]) return i + 1;
    }
    return 1;
  }

  AnswerButtonState _buttonState(String option) {
    if (!_showFeedback) {
      return _selectedAnswer == option
          ? AnswerButtonState.selected
          : AnswerButtonState.normal;
    }
    if (option == _currentQuestion.correctAnswer) {
      return AnswerButtonState.correct;
    }
    if (option == _selectedAnswer) {
      return AnswerButtonState.incorrect;
    }
    return AnswerButtonState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;
    final progress = (_currentIndex + 1) / _quiz.questions.length;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: LessonProgressBar(progress: progress),
        titleSpacing: 8,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  NekoMascot(
                    size: 80,
                    mood: _showFeedback
                        ? (_isCorrect == true
                            ? MascotMood.excited
                            : MascotMood.sad)
                        : MascotMood.thinking,
                    showSpeechBubble: _showFeedback
                        ? (_isCorrect == true
                            ? 'Sugoi! にゃん! 🎉'
                            : 'Try again! You got this!')
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.skillPath, width: 2),
                    ),
                    child: Text(
                      q.question,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (q.type == QuestionType.listening) ...[
                    Center(
                      child: PronunciationButton(
                        japanese: q.correctAnswer.contains(' ')
                            ? q.correctAnswer
                            : _extractJapanese(q.question),
                        audio: ref.read(audioServiceProvider),
                        size: 72,
                        label: 'Play audio',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ...q.options.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DuolingoAnswerButton(
                        number: entry.key + 1,
                        label: entry.value,
                        state: _buttonState(entry.value),
                        onTap: _showFeedback
                            ? () {}
                            : () => setState(() => _selectedAnswer = entry.value),
                      ),
                    );
                  }),
                  if (_showFeedback && q.explanation != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (_isCorrect == true
                                ? AppColors.success
                                : AppColors.error)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isCorrect == true
                              ? AppColors.success
                              : AppColors.error,
                          width: 2,
                        ),
                      ),
                      child: Text(q.explanation!),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.skillPath, width: 2)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showFeedback
                      ? _nextQuestion
                      : (_selectedAnswer != null ? _submitAnswer : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showFeedback
                        ? AppColors.secondary
                        : AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _showFeedback
                        ? (_currentIndex < _quiz.questions.length - 1
                            ? 'CONTINUE'
                            : 'SEE RESULTS')
                        : 'CHECK',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractJapanese(String question) {
    final match = RegExp(r'[ぁ-んァ-ン一-龯]+').firstMatch(question);
    return match?.group(0) ?? 'こんにちは';
  }
}
