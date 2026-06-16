import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../data/phrases_repository.dart';
import '../../providers/app_providers.dart';
import '../../services/speech_service.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../utils/safe_init.dart';

/// Real conversation role-play — speak each line to build fluency.
class ConversationPracticeScreen extends ConsumerStatefulWidget {
  const ConversationPracticeScreen({super.key, this.scenarioId});

  final String? scenarioId;

  @override
  ConsumerState<ConversationPracticeScreen> createState() =>
      _ConversationPracticeScreenState();
}

class _ConversationPracticeScreenState
    extends ConsumerState<ConversationPracticeScreen> {
  late ConversationScenario _scenario;
  int _lineIndex = 0;
  bool _listening = false;
  String _spoken = '';
  bool? _passed;

  @override
  void initState() {
    super.initState();
    _scenario = PhrasesRepository.conversationScenarios.firstWhere(
      (s) => s.id == widget.scenarioId,
      orElse: () => PhrasesRepository.conversationScenarios.first,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    useLessonServices(ref);
  }

  ScenarioLine get _line => _scenario.lines[_lineIndex];

  Future<void> _speak() async {
    setState(() {
      _listening = true;
      _spoken = '';
      _passed = null;
    });
    await ref.read(speechServiceProvider).listen(
          onResult: (t) => setState(() => _spoken = t),
          onListening: (_) {},
        );
  }

  Future<void> _check() async {
    await ref.read(speechServiceProvider).stop();
    final passed = SpeechService.matchesExpected(
      _spoken,
      _line.japanese,
      romaji: _line.romaji,
    );
    if (passed) await ref.read(audioServiceProvider).playCorrect();
    setState(() {
      _listening = false;
      _passed = passed;
    });
  }

  void _next() {
    if (_lineIndex < _scenario.lines.length - 1) {
      setState(() {
        _lineIndex++;
        _spoken = '';
        _passed = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.read(audioServiceProvider);
    final line = _line;
    final isUser = line.isUserLine;

    return Scaffold(
      appBar: AppBar(title: Text(_scenario.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Line ${_lineIndex + 1}/${_scenario.lines.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            NekoMascot(
              size: 80,
              mood: _passed == true ? MascotMood.cheering : MascotMood.happy,
              showSpeechBubble: isUser
                  ? 'Your turn — say this line!'
                  : 'Listen to ${line.speaker}',
            ),
            const Spacer(),
            Align(
              alignment:
                  line.speaker == 'You' ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUser ? AppColors.primary : AppColors.secondary,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(line.speaker,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(line.japanese,
                        style: const TextStyle(fontSize: 22)),
                    Text(line.romaji),
                    Text(line.english),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PronunciationButton(japanese: line.japanese, audio: audio),
            if (isUser) ...[
              const SizedBox(height: 24),
              if (_spoken.isNotEmpty) Text('You said: $_spoken'),
              if (_passed != null)
                Text(
                  _passed! ? 'Perfect!' : 'Try again — listen first',
                  style: TextStyle(
                    color: _passed! ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _listening ? _check : _speak,
                icon: Icon(_listening ? Icons.stop : Icons.mic),
                label: Text(_listening ? 'CHECK' : 'SPEAK THIS LINE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              if (_passed == true)
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('NEXT LINE'),
                ),
            ] else ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('NEXT'),
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
