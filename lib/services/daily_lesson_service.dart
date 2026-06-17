import '../data/course_repository.dart';
import '../data/phrases_repository.dart';
import '../models/lesson_models.dart';
import '../utils/japanese_tokens.dart';
import '../utils/lesson_type.dart';

/// Lesson listen/speak drills — keyed by lesson id (unit-based modules).
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
    return CourseRepository.getLessonsForModule('unit_1').firstOrNull;
  }

  List<SpeakDrill> getSpeakDrillsForLesson(String lessonId) {
    final lesson = CourseRepository.getLesson(lessonId);
    if (lesson == null) return _defaultDrills();

    if (LessonType.isKana(lesson.id)) {
      final basic = LessonType.isKatakana(lesson.id)
          ? CourseRepository.katakanaCharacters
          : CourseRepository.hiraganaCharacters;
      final chars = basic.take(LessonType.drillCount(lesson)).toList();
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

    if (LessonType.isVocabulary(lesson.id)) {
      final cat = LessonType.vocabCategory(lesson.id)!;
      return CourseRepository.vocabularyByCategory(cat)
          .take(LessonType.drillCount(lesson))
          .map(
            (v) => SpeakDrill(
              japanese: v.japanese,
              romaji: v.romaji,
              english: v.english,
              hint: v.romaji,
            ),
          )
          .toList();
    }

    if (LessonType.isConversation(lesson.id)) {
      return PhrasesRepository.speakDrills
          .take(LessonType.drillCount(lesson))
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

    if (LessonType.isGrammar(lesson.id)) {
      return PhrasesRepository.speakDrills
          .take(LessonType.drillCount(lesson))
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

    return _defaultDrills(limit: LessonType.drillCount(lesson));
  }

  List<SpeakDrill> _defaultDrills({int limit = 5}) {
    return PhrasesRepository.speakDrills
        .take(limit)
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
    return getListenExercisesForLesson(lessonId)
        .map(
          (e) => ListenItem(
            japanese: e.japanese,
            romaji: e.romaji,
            english: e.english,
          ),
        )
        .toList();
  }

  /// Varied Duolingo-style listen drills — rotate exercise types per phrase.
  List<ListenExercise> getListenExercisesForLesson(String lessonId) {
    final drills = getSpeakDrillsForLesson(lessonId);
    if (drills.isEmpty) return [];

    final pool = _distractorPool(lessonId);
    return drills.asMap().entries.map((entry) {
      final i = entry.key;
      final d = entry.value;
      final tokens = JapaneseTokens.tokenize(d.japanese);
      final canBuild = tokens.length >= 2;

      final type = switch (i % 4) {
        0 when canBuild => ListenExerciseType.translateBuild,
        1 => ListenExerciseType.listenSelect,
        2 => ListenExerciseType.readSelect,
        _ when canBuild => ListenExerciseType.translateBuild,
        _ => ListenExerciseType.listenReveal,
      };

      if (LessonType.isKana(lessonId)) {
        return ListenExercise(
          type: i.isEven ? ListenExerciseType.listenSelect : ListenExerciseType.readSelect,
          japanese: d.japanese,
          romaji: d.romaji,
          english: d.english,
          correctOption: i.isEven ? d.romaji : d.japanese,
          options: i.isEven
              ? _options(d.romaji, drills.map((x) => x.romaji).toList())
              : _options(d.japanese, drills.map((x) => x.japanese).toList()),
        );
      }

      return switch (type) {
        ListenExerciseType.translateBuild => ListenExercise(
            type: type,
            japanese: d.japanese,
            romaji: d.romaji,
            english: d.english,
            wordBank: JapaneseTokens.buildWordBank(
              tokens,
              distractors: pool.where((w) => !tokens.contains(w)).take(3).toList(),
            ),
            correctOption: d.japanese,
          ),
        ListenExerciseType.listenSelect => ListenExercise(
            type: type,
            japanese: d.japanese,
            romaji: d.romaji,
            english: d.english,
            correctOption: d.english,
            options: _options(d.english, drills.map((x) => x.english).toList()),
          ),
        ListenExerciseType.readSelect => ListenExercise(
            type: type,
            japanese: d.japanese,
            romaji: d.romaji,
            english: d.english,
            correctOption: d.japanese,
            options: _options(d.japanese, drills.map((x) => x.japanese).toList()),
          ),
        ListenExerciseType.listenReveal => ListenExercise(
            type: type,
            japanese: d.japanese,
            romaji: d.romaji,
            english: d.english,
            correctOption: d.japanese,
          ),
      };
    }).toList();
  }

  List<String> _distractorPool(String lessonId) {
    if (LessonType.isVocabulary(lessonId)) {
      final cat = LessonType.vocabCategory(lessonId);
      if (cat != null) {
        return CourseRepository.vocabularyByCategory(cat)
            .map((v) => JapaneseTokens.tokenize(v.japanese))
            .expand((t) => t)
            .toList();
      }
    }
    return ['は', 'を', 'です', 'か', 'の', 'に', 'と', 'これ', 'それ'];
  }

  List<String> _options(String correct, List<String> pool) {
    final others = pool.where((o) => o != correct).toSet().take(3).toList();
    while (others.length < 3) {
      others.add('—');
    }
    final opts = [correct, ...others]..shuffle();
    return opts.take(4).toList();
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

enum ListenExerciseType {
  translateBuild,
  listenSelect,
  readSelect,
  listenReveal,
}

class ListenExercise {
  const ListenExercise({
    required this.type,
    required this.japanese,
    required this.romaji,
    required this.english,
    this.correctOption = '',
    this.options = const [],
    this.wordBank = const [],
  });

  final ListenExerciseType type;
  final String japanese;
  final String romaji;
  final String english;
  final String correctOption;
  final List<String> options;
  final List<String> wordBank;
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
