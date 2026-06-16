import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../models/lesson_models.dart';
import '../../widgets/practice/pronunciation_button.dart';
import '../../services/audio_service.dart';

class LessonLearnStep extends StatelessWidget {
  const LessonLearnStep({
    super.key,
    required this.lesson,
    this.audio,
  });

  final LessonModel lesson;
  final AudioService? audio;

  @override
  Widget build(BuildContext context) {
    final module = CourseRepository.getModule(lesson.moduleId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (module != null)
                  Chip(
                    label: Text(module.title),
                    backgroundColor:
                        Color(module.color).withValues(alpha: 0.15),
                  ),
                const SizedBox(height: 12),
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: AppColors.lightTextSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${lesson.estimatedMinutes} min • +${lesson.xpReward} XP',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (lesson.moduleId == 'hiragana' || lesson.moduleId == 'katakana') {
      return _KanaGrid(type: lesson.moduleId);
    }
    if (lesson.moduleId == 'vocabulary') {
      final cat = lesson.id.replaceFirst('vocab_', '');
      return _VocabList(category: cat, audio: audio);
    }
    if (lesson.moduleId == 'grammar') {
      return _GrammarBlock(topicId: lesson.id);
    }
    if (lesson.moduleId == 'conversations') {
      return _ConversationBlock(topicId: lesson.id, audio: audio);
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Study the content, then listen, speak, and take the quiz!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _KanaGrid extends StatelessWidget {
  const _KanaGrid({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final chars = type == 'hiragana'
        ? CourseRepository.hiraganaCharacters.take(20)
        : CourseRepository.katakanaCharacters.take(20);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chars.map((c) {
        return Container(
          width: 64,
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.skillPath, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.character, style: const TextStyle(fontSize: 26)),
              Text(c.romaji, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _VocabList extends StatelessWidget {
  const _VocabList({required this.category, this.audio});
  final String category;
  final AudioService? audio;

  @override
  Widget build(BuildContext context) {
    final words = CourseRepository.vocabularyByCategory(category);
    return Column(
      children: words.map((w) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(w.japanese, style: const TextStyle(fontSize: 22)),
            subtitle: Text('${w.romaji} — ${w.english}'),
            trailing: audio != null
                ? PronunciationButton(
                    japanese: w.japanese,
                    audio: audio!,
                    size: 44,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _GrammarBlock extends StatelessWidget {
  const _GrammarBlock({required this.topicId});
  final String topicId;

  static const _content = {
    'gram_structure': (
      'Sentence Structure (SOV)',
      'Japanese uses Subject-Object-Verb order.\n\n私は本を読みます。\nWatashi wa hon wo yomimasu.\n"I read a book."',
    ),
    'gram_particles': (
      'Particles',
      'は (wa) = topic\nを (wo) = object\nに (ni) = direction/time\nで (de) = location/means',
    ),
    'gram_verbs': (
      'Verbs',
      'Group 1: ends in -u (行く iku)\nGroup 2: -iru/-eru (食べる taberu)\nGroup 3: する、来る',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = _content[topicId] ?? ('Grammar', 'Study the grammar points.');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.$1, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(c.$2, style: const TextStyle(fontSize: 16, height: 1.6)),
          ],
        ),
      ),
    );
  }
}

class _ConversationBlock extends StatelessWidget {
  const _ConversationBlock({required this.topicId, this.audio});
  final String topicId;
  final AudioService? audio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Key Phrases', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final phrase in [
              ('こんにちは', 'Konnichiwa', 'Hello'),
              ('ありがとう', 'Arigatou', 'Thank you'),
              ('すみません', 'Sumimasen', 'Excuse me'),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phrase.$1,
                              style: const TextStyle(fontSize: 20)),
                          Text('${phrase.$2} — ${phrase.$3}'),
                        ],
                      ),
                    ),
                    if (audio != null)
                      PronunciationButton(
                        japanese: phrase.$1,
                        audio: audio!,
                        size: 40,
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
