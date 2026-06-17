import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';
import '../../utils/platform_layout.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({super.key, required this.levelId});

  final String levelId;

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  CertificationExam? _exam;
  int _sectionIndex = 0;
  int _questionIndex = 0;
  final Map<String, Map<String, String>> _answers = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  Future<void> _loadExam() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      setState(() {
        _error = 'Please sign in';
        _loading = false;
      });
      return;
    }

    final canTake = await ref
        .read(examServiceProvider)
        .canTakeExam(user, widget.levelId);
    if (!canTake) {
      setState(() {
        _error = 'Complete required modules first or certificate already earned';
        _loading = false;
      });
      return;
    }

    final exam =
        await ref.read(examServiceProvider).getExamForLevel(widget.levelId);
    setState(() {
      _exam = exam;
      _loading = false;
    });
  }

  ExamSection? get _currentSection =>
      _exam != null && _sectionIndex < _exam!.sections.length
          ? _exam!.sections[_sectionIndex]
          : null;

  QuizQuestion? get _currentQuestion {
    final section = _currentSection;
    if (section == null || _questionIndex >= section.questions.length) {
      return null;
    }
    return section.questions[_questionIndex];
  }

  void _selectAnswer(String answer) {
    final section = _currentSection;
    final question = _currentQuestion;
    if (section == null || question == null) return;

    setState(() {
      _answers.putIfAbsent(section.id, () => {})[question.id] = answer;
    });
  }

  void _next() {
    final section = _currentSection!;
    if (_questionIndex < section.questions.length - 1) {
      setState(() => _questionIndex++);
    } else if (_sectionIndex < _exam!.sections.length - 1) {
      setState(() {
        _sectionIndex++;
        _questionIndex = 0;
      });
    } else {
      _submitExam();
    }
  }

  Future<void> _submitExam() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null || _exam == null) return;

    final certificate = await ref.read(examServiceProvider).submitExam(
          user: user,
          exam: _exam!,
          answers: _answers,
        );

    final result = ref.read(examServiceProvider).calculateResult(
          exam: _exam!,
          answers: _answers,
          userId: user.uid,
        );

    ref.invalidate(currentUserProvider);

    if (mounted) {
      context.pushReplacement('/exam-result', extra: {
        'result': result,
        'certificate': certificate,
        'levelId': widget.levelId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: PlatformLayout.pagePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 64),
                  const SizedBox(height: 16),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final section = _currentSection!;
    final question = _currentQuestion!;
    final levelInfo = AppConstants.certificateLevels[widget.levelId]!;
    final selected = _answers[section.id]?[question.id];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${levelInfo.title} Exam'),
            Text(
              '${section.title} • Q${_questionIndex + 1}/${section.questions.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
          child: Padding(
            padding: PlatformLayout.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (_sectionIndex * section.questions.length +
                          _questionIndex +
                          1) /
                      (_exam!.sections.length * section.questions.length),
                ),
                const SizedBox(height: 8),
                Text(
                  'Section ${_sectionIndex + 1}/${_exam!.sections.length}: ${section.title} (${section.maxMarks} marks)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: question.options.map((option) {
                      final isSelected = selected == option;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton(
                          onPressed: () => _selectAnswer(option),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(option),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: selected != null ? _next : null,
                  child: Text(
                    _sectionIndex == _exam!.sections.length - 1 &&
                            _questionIndex == section.questions.length - 1
                        ? 'Submit Exam'
                        : 'Next',
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
