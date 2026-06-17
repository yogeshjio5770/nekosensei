import '../models/lesson_models.dart';

/// Resolve lesson content type by lesson id (works with unit_1…unit_7 modules).
class LessonType {
  LessonType._();

  static bool isHiragana(String lessonId) => lessonId.startsWith('hira_');
  static bool isKatakana(String lessonId) => lessonId.startsWith('kata_');
  static bool isKana(String lessonId) => isHiragana(lessonId) || isKatakana(lessonId);

  static bool isVocabulary(String lessonId) => lessonId.startsWith('vocab_');
  static bool isGrammar(String lessonId) => lessonId.startsWith('gram_');
  static bool isConversation(String lessonId) => lessonId.startsWith('conv_');
  static bool isReading(String lessonId) => lessonId.startsWith('read_');
  static bool isJlpt(String lessonId) => lessonId.startsWith('jlpt_');

  static String? vocabCategory(String lessonId) =>
      isVocabulary(lessonId) ? lessonId.replaceFirst('vocab_', '') : null;

  static String kanaType(String lessonId) =>
      isKatakana(lessonId) ? 'katakana' : 'hiragana';

  static int drillCount(LessonModel lesson) {
    if (isKana(lesson.id)) return 6;
    if (isVocabulary(lesson.id)) return 5;
    if (isGrammar(lesson.id) || isConversation(lesson.id)) return 4;
    if (isReading(lesson.id) || isJlpt(lesson.id)) return 3;
    return 4;
  }
}
