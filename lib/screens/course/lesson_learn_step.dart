import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../utils/lesson_type.dart';
import '../../data/expanded_content.dart';
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
    final surface = Theme.of(context).colorScheme.surface;

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
                    Icon(Icons.timer,
                        size: 16, color: Theme.of(context).hintColor),
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
        _buildContent(context, surface),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Color surface) {
    final id = lesson.id;

    if (LessonType.isKana(id)) {
      return _KanaGrid(
        lessonId: id,
        type: LessonType.kanaType(id),
      );
    }
    if (LessonType.isVocabulary(id)) {
      return _VocabList(
        category: LessonType.vocabCategory(id)!,
        audio: audio,
      );
    }
    if (LessonType.isGrammar(id)) {
      return _GrammarBlock(topicId: id);
    }
    if (LessonType.isConversation(id)) {
      return _ConversationBlock(topicId: id, audio: audio);
    }
    if (LessonType.isReading(id)) {
      return _ReadingBlock(topicId: id);
    }
    if (LessonType.isJlpt(id)) {
      return _JlptBlock(lessonId: id);
    }
    return _PlaceholderCard(
      text: 'Study the content, then listen, speak, and take the quiz!',
    );
  }
}

class _KanaGrid extends StatelessWidget {
  const _KanaGrid({required this.lessonId, required this.type});
  final String lessonId;
  final String type;

  @override
  Widget build(BuildContext context) {
    final basic = type == 'hiragana'
        ? CourseRepository.hiraganaCharacters
        : CourseRepository.katakanaCharacters;
    final chars = ExpandedContent.kanaForLesson(lessonId, basic);
    final accent = type == 'hiragana' ? AppColors.primary : AppColors.secondary;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chars.asMap().entries.map((entry) {
        final c = entry.value;
        return Container(
          width: 68,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.35), width: 2),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.12),
                offset: const Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.character,
                  style: TextStyle(fontSize: 28, color: accent)),
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
      children: words.asMap().entries.map((entry) {
        final w = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.accent.withValues(alpha: 0.2),
              child: Text(
                w.japanese.characters.first,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            title: Text(w.japanese, style: const TextStyle(fontSize: 22)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${w.romaji} — ${w.english}'),
                if (w.exampleSentence != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    w.exampleSentence!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    final c = ExpandedContent.grammarTopics[topicId] ??
        ('Grammar', 'Study the grammar points for this lesson.');
    return _ContentCard(
      title: c.$1,
      body: c.$2,
      icon: Icons.auto_stories,
      color: AppColors.success,
    );
  }
}

class _ConversationBlock extends StatelessWidget {
  const _ConversationBlock({required this.topicId, this.audio});
  final String topicId;
  final AudioService? audio;

  @override
  Widget build(BuildContext context) {
    final phrases = ExpandedContent.conversationPhrases[topicId] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Key Phrases', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...phrases.asMap().entries.map((entry) {
          final p = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.$1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 4),
                        Text('${p.$2} — ${p.$3}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  if (audio != null)
                    PronunciationButton(
                      japanese: p.$1,
                      audio: audio!,
                      size: 44,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ReadingBlock extends StatelessWidget {
  const _ReadingBlock({required this.topicId});
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final c = ExpandedContent.readingPassages[topicId] ??
        ('Reading', 'Read and understand the passage.');
    return _ContentCard(
      title: c.$1,
      body: c.$2,
      icon: Icons.menu_book,
      color: const Color(0xFFCE82FF),
    );
  }
}

class _JlptBlock extends StatelessWidget {
  const _JlptBlock({required this.lessonId});
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final (title, body) = switch (lessonId) {
      'jlpt_vocab' => (
          'N5 Vocabulary Review',
          'Review ${CourseRepository.vocabulary.length} essential words across all categories.\n\nFocus on nouns, verbs, and daily expressions tested on JLPT N5.',
        ),
      'jlpt_grammar' => (
          'N5 Grammar Review',
          'Particles (は, を, に, で), ます-form verbs, い/な-adjectives, and question patterns.',
        ),
      'jlpt_practice' => (
          'Full Practice Test',
          'Simulated N5 exam: vocabulary, grammar, reading, and listening sections combined.',
        ),
      _ => (
          'Timed Speed Drill',
          'Answer quickly under pressure — just like the real JLPT time constraints!',
        ),
    };
    return _ContentCard(
      title: title,
      body: body,
      icon: Icons.workspace_premium,
      color: AppColors.primary,
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(body, style: const TextStyle(fontSize: 16, height: 1.65)),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
