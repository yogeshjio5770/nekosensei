import '../data/course_repository.dart';
import '../data/phrases_repository.dart';
import '../models/lesson_models.dart';

/// Picks a focused 5-minute daily lesson: learn + listen + speak fast.
class DailyLessonService {
  DailyBoost pickDailyBoost(List<String> completedLessons) {
    final next = _nextIncompleteLesson(completedLessons);
    final phrases = PhrasesRepository.dailyPhrases.take(3).toList();
    final vocab = CourseRepository.vocabulary.take(4).toList();

    return DailyBoost(
      lesson: next,
      phrases: phrases,
      vocabulary: vocab,
      estimatedMinutes: 5,
      title: next != null ? 'Continue: ${next.title}' : 'Daily Japanese Boost',
    );
  }

  LessonModel? _nextIncompleteLesson(List<String> completed) {
    for (final module in CourseRepository.modules) {
      for (final lesson in CourseRepository.getLessonsForModule(module.id)) {
        if (!completed.contains(lesson.id)) return lesson;
      }
    }
    return CourseRepository.getLessonsForModule('hiragana').firstOrNull;
  }

  List<SpeakDrill> getSpeakDrillsForLesson(String lessonId) {
    final lesson = CourseRepository.getLesson(lessonId);
    if (lesson == null) return PhrasesRepository.speakDrills.take(5).toList();

    if (lesson.moduleId == 'hiragana' || lesson.moduleId == 'katakana') {
      final chars = lesson.moduleId == 'hiragana'
          ? CourseRepository.hiraganaCharacters.take(8)
          : CourseRepository.katakanaCharacters.take(8);
      return chars
          .map(
            (c) => SpeakDrill(
              japanese: c.character,
              romaji: c.romaji,
              english: 'Say "${c.romaji}"',
              hint: c.romaji,
            ),
          )
          .toList();
    }

    if (lesson.moduleId == 'vocabulary') {
      final cat = lesson.id.replaceFirst('vocab_', '');
      return CourseRepository.vocabularyByCategory(cat)
          .map(
            (v) => SpeakDrill(
              japanese: v.japanese,
              romaji: v.romaji,
              english: v.english,
              hint: v.romaji,
            ),
          )
          .take(6)
          .toList();
    }

    if (lesson.moduleId == 'conversations') {
      return PhrasesRepository.speakDrills
          .map(
            (e) => SpeakDrill(
              japanese: e.japanese,
              romaji: e.romaji,
              english: e.english,
              hint: e.hint,
            ),
          )
          .toList();
    }

    return PhrasesRepository.speakDrills
        .take(5)
        .map(
          (e) => SpeakDrill(
            japanese: e.japanese,
            romaji: e.romaji,
            english: e.english,
            hint: e.hint,
          ),
        )
        .toList();
  }

  List<ListenItem> getListenItemsForLesson(String lessonId) {
    return getSpeakDrillsForLesson(lessonId)
        .map(
          (d) => ListenItem(
            japanese: d.japanese,
            romaji: d.romaji,
            english: d.english,
          ),
        )
        .toList();
  }
}

class DailyBoost {
  const DailyBoost({
    required this.lesson,
    required this.phrases,
    required this.vocabulary,
    required this.estimatedMinutes,
    required this.title,
  });

  final LessonModel? lesson;
  final List<DailyPhrase> phrases;
  final List<VocabularyItem> vocabulary;
  final int estimatedMinutes;
  final String title;
}

class SpeakDrill {
  const SpeakDrill({
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.hint,
  });

  final String japanese;
  final String romaji;
  final String english;
  final String hint;
}

class ListenItem {
  const ListenItem({
    required this.japanese,
    required this.romaji,
    required this.english,
  });

  final String japanese;
  final String romaji;
  final String english;
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
