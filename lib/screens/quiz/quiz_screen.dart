import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../data/lesson_quizzes.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';
import '../../services/haptic_service.dart';
import '../../services/speech_service.dart';
import '../../widgets/common/lesson_progress_bar.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../utils/platform_layout.dart';
import '../../utils/quiz_answer_checker.dart';
import '../../widgets/quiz/duolingo_answer_button.dart';
import '../../widgets/quiz/match_pairs_widget.dart';
import '../../widgets/quiz/type_answer_field.dart';
import '../../widgets/quiz/kanji_canvas.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late QuizModel _quiz;
  int _currentIndex = 0;
  int _combo = 0;
  int _maxCombo = 0;
  final Map<String, String> _answers = {};
  String? _selectedAnswer;
  bool _showFeedback = false;
  bool? _isCorrect;
  bool _matchComplete = false;
  final _typeController = TextEditingController();
  bool _listening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _quiz = LessonQuizzes.forLesson(widget.lessonId);
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  QuizQuestion get _currentQuestion => _quiz.questions[_currentIndex];

  bool get _canSubmit {
    final q = _currentQuestion;
    if (q.type == QuestionType.speaking) {
      return true; // Always allow submitting speaking questions
    }
    if (q.type == QuestionType.matchWord || q.type == QuestionType.kanjiDraw) {
      return _matchComplete;
    }
    if (q.type == QuestionType.fillInBlank) {
      return _selectedAnswer != null && _selectedAnswer!.trim().isNotEmpty;
    }
    return _selectedAnswer != null;
  }

  Future<void> _startListening() async {
    final speechService = ref.read(speechServiceProvider);
    if (!speechService.isAvailable) await speechService.initialize();
    if (!speechService.isAvailable) return;
    
    setState(() {
      _listening = true;
      _spokenText = '';
    });
    
    await speechService.listen(
      onResult: (text) {
        if (mounted) setState(() => _spokenText = text);
      },
      onListening: (isListening) {
        if (mounted) setState(() => _listening = isListening);
      },
    );
  }
  
  Future<void> _stopListening() async {
    final speechService = ref.read(speechServiceProvider);
    await speechService.stop();
  }

  Future<void> _submitAnswer() async {
    if (!_canSubmit) return;
    final q = _currentQuestion;
    String answer;
    bool correct;
    
    if (q.type == QuestionType.speaking) {
      answer = _spokenText;
      // For speaking, mark as correct if they tried, or check with SpeechService
      correct = true; // Always allow passing speaking questions to avoid frustration
      // Or use: SpeechService.matchesExpected(_spokenText, q.correctAnswer);
    } else if (q.type == QuestionType.matchWord || q.type == QuestionType.kanjiDraw) {
      answer = q.correctAnswer;
      correct = _matchComplete;
    } else {
      answer = _selectedAnswer!;
      correct = QuizAnswerChecker.isCorrect(answer, q.correctAnswer);
    }

    if (correct) {
      await HapticService.correctAnswer();
      await ref.read(audioServiceProvider).playCorrect();
    } else {
      await HapticService.wrongAnswer();
      await ref.read(audioServiceProvider).playWrong();
    }

    setState(() {
      _answers[q.id] = answer;
      _showFeedback = true;
      _isCorrect = correct;
      if (correct) {
        _combo++;
        if (_combo > _maxCombo) _maxCombo = _combo;
      } else {
        _combo = 0;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
        _isCorrect = null;
        _matchComplete = false;
        _typeController.clear();
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    var correct = 0;
    for (final q in _quiz.questions) {
      if (QuizAnswerChecker.isCorrect(
        _answers[q.id] ?? '',
        q.correctAnswer,
      )) {
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
      try {
        await ref.read(progressServiceProvider).completeLesson(
              userId: user.uid,
              lessonId: widget.lessonId,
              moduleId: lesson.moduleId,
              quizScore: score,
              xpEarned: xp,
            );
      } catch (_) {}
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
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: LessonProgressBar(progress: progress),
        titleSpacing: 8,
        actions: [
          if (_combo >= 2)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, color: AppColors.accent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$_combo COMBO',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(key: ValueKey(_combo))
                    .scale(curve: Curves.elasticOut, duration: 400.ms),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: PlatformLayout.contentWidth(context),
                ),
                child: SingleChildScrollView(
                  padding: PlatformLayout.pagePadding(context),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.08, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey(_currentIndex),
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
                                  ? (_combo >= 3
                                      ? 'On fire! $_combo streak! 🔥'
                                      : 'Sugoi! にゃん! 🎉')
                                  : 'Try again! You got this!')
                              : null,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: AppColors.skillPath, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.08),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Text(
                            q.question,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ).animate().fadeIn().scale(
                              begin: const Offset(0.95, 0.95),
                              curve: Curves.easeOut,
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
                        if (q.type == QuestionType.speaking) ...[
                          Center(
                            child: Column(
                              children: [
                                PronunciationButton(
                                  japanese: q.correctAnswer,
                                  audio: ref.read(audioServiceProvider),
                                  size: 72,
                                  label: 'Listen first',
                                ),
                                const SizedBox(height: 16),
                                if (_spokenText.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.skillPath, width: 2),
                                    ),
                                    child: Text('You said: $_spokenText', textAlign: TextAlign.center),
                                  ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: _listening ? _stopListening : _startListening,
                                  icon: Icon(_listening ? Icons.stop : Icons.mic),
                                  label: Text(_listening ? 'Stop' : 'Try Speaking'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _listening ? AppColors.error : AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (q.type == QuestionType.matchWord &&
                            q.matchPairs.isNotEmpty) ...[
                          MatchPairsWidget(
                            pairs: q.matchPairs,
                            showFeedback: _showFeedback,
                            isCorrect: _isCorrect == true,
                            onComplete: () => setState(() {
                              _matchComplete = true;
                              _selectedAnswer = q.correctAnswer;
                            }),
                          ),
                        ] else if (q.type == QuestionType.fillInBlank) ...[
                          TypeAnswerField(
                            controller: _typeController,
                            wordBank: q.options,
                            showFeedback: _showFeedback,
                            isCorrect: _isCorrect == true,
                            correctAnswer: q.correctAnswer,
                            onChanged: (v) =>
                                setState(() => _selectedAnswer = v),
                          ),
                        ] else if (q.type == QuestionType.kanjiDraw) ...[
                          KanjiCanvas(
                            kanji: q.correctAnswer,
                            onPassed: () {
                              setState(() {
                                _matchComplete = true;
                                _selectedAnswer = q.correctAnswer;
                              });
                              _submitAnswer();
                            },
                          ),
                        ] else ...[
                          ...q.options.asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DuolingoAnswerButton(
                                number: entry.key + 1,
                                label: entry.value,
                                state: _buttonState(entry.value),
                                onTap: _showFeedback
                                    ? () {}
                                    : () => setState(
                                          () => _selectedAnswer = entry.value,
                                        ),
                              ),
                            )
                                .animate(delay: (entry.key * 80).ms)
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: 0.06, curve: Curves.easeOut);
                          }),
                        ],
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
                          ).animate().fadeIn().slideY(begin: 0.1),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface,
              border:
                  Border(top: BorderSide(color: AppColors.skillPath, width: 2)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showFeedback
                      ? _nextQuestion
                      : (_canSubmit ? _submitAnswer : null),
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
