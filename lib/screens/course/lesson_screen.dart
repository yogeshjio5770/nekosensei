import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/course_repository.dart';
import '../../widgets/common/app_button.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final lesson = CourseRepository.getLesson(lessonId);
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final module = CourseRepository.getModule(lesson.moduleId);

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                      lesson.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _LessonContent(lesson: lesson),
            const SizedBox(height: 32),
            AppButton(
              label: 'Start Quiz',
              icon: Icons.quiz,
              onPressed: () => context.push('/quiz/$lessonId'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({required this.lesson});
  final dynamic lesson;

  @override
  Widget build(BuildContext context) {
    if (lesson.moduleId == 'hiragana' || lesson.moduleId == 'katakana') {
      return _KanaPreview(type: lesson.moduleId);
    }
    if (lesson.moduleId == 'vocabulary') {
      final category = lesson.id.replaceFirst('vocab_', '');
      return _VocabPreview(category: category);
    }
    if (lesson.moduleId == 'grammar') {
      return _GrammarPreview(topicId: lesson.id);
    }
    if (lesson.moduleId == 'conversations') {
      return _ConversationPreview(topicId: lesson.id);
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Study the material above, then take the quiz to complete this lesson.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _KanaPreview extends StatelessWidget {
  const _KanaPreview({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final chars = type == 'hiragana'
        ? CourseRepository.hiraganaCharacters.take(15)
        : CourseRepository.katakanaCharacters.take(15);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chars.map((c) {
        return Container(
          width: 64,
          height: 72,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.character, style: const TextStyle(fontSize: 24)),
              Text(c.romaji, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _VocabPreview extends StatelessWidget {
  const _VocabPreview({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final words = CourseRepository.vocabularyByCategory(category);
    return Column(
      children: words.map((w) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(w.japanese, style: const TextStyle(fontSize: 20)),
            subtitle: Text('${w.romaji} — ${w.english}'),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {},
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GrammarPreview extends StatelessWidget {
  const _GrammarPreview({required this.topicId});
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final content = _grammarContent[topicId] ?? {};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content['title'] ?? 'Grammar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(content['explanation'] ?? ''),
            if (content['example'] != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  content['example']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static const _grammarContent = {
    'gram_structure': {
      'title': 'Sentence Structure (SOV)',
      'explanation':
          'Japanese sentences follow Subject-Object-Verb order, unlike English SVO.',
      'example': '私はりんごを食べます。\n(Watashi wa ringo wo tabemasu.)\n"I eat an apple."',
    },
    'gram_particles': {
      'title': 'Particles',
      'explanation':
          'Particles are grammatical markers. Key particles: は (topic), を (object), に (direction/time), で (location/means).',
      'example': '学校に行きます。\n(Gakkou ni ikimasu.)\n"I go to school."',
    },
    'gram_verbs': {
      'title': 'Verbs',
      'explanation':
          'Japanese verbs end in -u sounds. There are 3 groups: Group 1 (godan), Group 2 (ichidan), Group 3 (irregular).',
      'example': '食べる (taberu) — to eat\n行く (iku) — to go',
    },
  };
}

class _ConversationPreview extends StatelessWidget {
  const _ConversationPreview({required this.topicId});
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final dialogue = _dialogues[topicId] ?? [];
    return Column(
      children: dialogue.map((line) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(line['speaker']![0]),
            ),
            title: Text(line['japanese']!, style: const TextStyle(fontSize: 18)),
            subtitle: Text('${line['romaji']}\n${line['english']}'),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {},
            ),
          ),
        );
      }).toList(),
    );
  }

  static const _dialogues = {
    'conv_greetings': [
      {
        'speaker': 'A',
        'japanese': 'おはようございます。',
        'romaji': 'Ohayou gozaimasu.',
        'english': 'Good morning.',
      },
      {
        'speaker': 'B',
        'japanese': 'おはようございます。',
        'romaji': 'Ohayou gozaimasu.',
        'english': 'Good morning.',
      },
    ],
    'conv_intro': [
      {
        'speaker': 'A',
        'japanese': 'はじめまして。田中です。',
        'romaji': 'Hajimemashite. Tanaka desu.',
        'english': 'Nice to meet you. I am Tanaka.',
      },
      {
        'speaker': 'B',
        'japanese': 'はじめまして。よろしくお願いします。',
        'romaji': 'Hajimemashite. Yoroshiku onegaishimasu.',
        'english': 'Nice to meet you. Please treat me well.',
      },
    ],
  };
}
