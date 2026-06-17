import 'package:equatable/equatable.dart';
import 'user_model.dart';

enum QuestionType {
  multipleChoice,
  matchWord,
  fillInBlank,
  listening,
  speaking,
  kanjiDraw,
}

enum LessonStep { learn, listen, speak, quiz }

class ModuleModel extends Equatable {
  const ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.iconName,
    required this.color,
    this.lessonIds = const [],
    this.isLocked = false,
  });

  final String id;
  final String title;
  final String description;
  final int order;
  final String iconName;
  final int color;
  final List<String> lessonIds;
  final bool isLocked;

  @override
  List<Object?> get props => [id, title, order];
}

class LessonModel extends Equatable {
  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.order,
    this.content = const {},
    this.quizIds = const [],
    this.xpReward = 25,
    this.estimatedMinutes = 10,
  });

  final String id;
  final String moduleId;
  final String title;
  final String description;
  final int order;
  final Map<String, dynamic> content;
  final List<String> quizIds;
  final int xpReward;
  final int estimatedMinutes;

  @override
  List<Object?> get props => [id, moduleId, title];
}

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    this.options = const [],
    this.explanation,
    this.audioUrl,
    this.matchPairs = const {},
  });

  final String id;
  final QuestionType type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? explanation;
  final String? audioUrl;
  final Map<String, String> matchPairs;

  @override
  List<Object?> get props => [id, type, question];
}

class QuizModel extends Equatable {
  const QuizModel({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.questions,
    this.timeLimitSeconds,
    this.passingScore = 70,
  });

  final String id;
  final String lessonId;
  final String title;
  final List<QuizQuestion> questions;
  final int? timeLimitSeconds;
  final int passingScore;

  @override
  List<Object?> get props => [id, lessonId];
}

class VocabularyItem extends Equatable {
  const VocabularyItem({
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.category,
    this.exampleSentence,
    this.exampleRomaji,
    this.exampleEnglish,
    this.audioUrl,
    this.kanji,
  });

  final String japanese;
  final String romaji;
  final String english;
  final String category;
  final String? exampleSentence;
  final String? exampleRomaji;
  final String? exampleEnglish;
  final String? audioUrl;
  final String? kanji;

  @override
  List<Object?> get props => [japanese, english];
}

class KanaCharacter extends Equatable {
  const KanaCharacter({
    required this.character,
    required this.romaji,
    required this.type,
    this.strokeOrder,
    this.audioUrl,
  });

  final String character;
  final String romaji;
  final String type;
  final List<String>? strokeOrder;
  final String? audioUrl;

  @override
  List<Object?> get props => [character, romaji];
}

class BadgeModel extends Equatable {
  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.xpRequired,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final int xpRequired;

  @override
  List<Object?> get props => [id, title];
}

class AchievementModel extends Equatable {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.earnedAt,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final DateTime earnedAt;
  final String iconName;

  @override
  List<Object?> get props => [id, title, earnedAt];
}

class ExamSection extends Equatable {
  const ExamSection({
    required this.id,
    required this.title,
    required this.maxMarks,
    required this.questions,
  });

  final String id;
  final String title;
  final int maxMarks;
  final List<QuizQuestion> questions;

  @override
  List<Object?> get props => [id, title];
}

class CertificationExam extends Equatable {
  const CertificationExam({
    required this.id,
    required this.levelId,
    required this.title,
    required this.sections,
    this.totalMarks = 100,
    this.passingScore = 70,
    this.timeLimitMinutes = 60,
  });

  final String id;
  final String levelId;
  final String title;
  final List<ExamSection> sections;
  final int totalMarks;
  final int passingScore;
  final int timeLimitMinutes;

  @override
  List<Object?> get props => [id, levelId];
}

class ExamResult extends Equatable {
  const ExamResult({
    required this.examId,
    required this.levelId,
    required this.userId,
    required this.totalScore,
    required this.sectionScores,
    required this.passed,
    required this.completedAt,
  });

  final String examId;
  final String levelId;
  final String userId;
  final int totalScore;
  final Map<String, int> sectionScores;
  final bool passed;
  final DateTime completedAt;

  @override
  List<Object?> get props => [examId, totalScore, passed];
}

class CertificateModel extends Equatable {
  const CertificateModel({
    required this.id,
    required this.userId,
    required this.studentName,
    required this.levelId,
    required this.levelTitle,
    required this.finalScore,
    required this.issuedAt,
    required this.verificationCode,
  });

  final String id;
  final String userId;
  final String studentName;
  final String levelId;
  final String levelTitle;
  final int finalScore;
  final DateTime issuedAt;
  final String verificationCode;

  @override
  List<Object?> get props => [id, verificationCode];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  @override
  List<Object?> get props => [id, content, isUser];
}

class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.xpPoints,
    required this.rank,
    this.photoUrl,
  });

  final String userId;
  final String displayName;
  final int xpPoints;
  final int rank;
  final String? photoUrl;

  @override
  List<Object?> get props => [userId, rank, xpPoints];
}
