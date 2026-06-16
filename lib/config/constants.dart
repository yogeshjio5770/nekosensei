import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // NekoSensei brand palette (from mascot logo)
  static const Color primary = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFC62828);
  static const Color secondary = Color(0xFF1565C0);
  static const Color secondaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFFFFB300);
  static const Color nekoOrange = Color(0xFFFF9800);
  static const Color bellGold = Color(0xFFFFD54F);

  static const Color success = Color(0xFF58CC02);
  static const Color successDark = Color(0xFF46A302);
  static const Color warning = Color(0xFFFF9600);
  static const Color error = Color(0xFFFF4B4B);
  static const Color errorDark = Color(0xFFEA2B2B);
  static const Color xpGold = Color(0xFFFFC800);

  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF3C3C3C);
  static const Color lightTextSecondary = Color(0xFF777777);

  static const Color darkBackground = Color(0xFF131F24);
  static const Color darkSurface = Color(0xFF1A2C35);
  static const Color darkText = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  static const Color skillPath = Color(0xFFE5E5E5);
  static const Color skillLocked = Color(0xFFD4D4D4);
}

class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/nekosensei_logo.png';
}

class AppConstants {
  AppConstants._();

  static const String appName = 'NekoSensei';
  static const String appTagline =
      'Speak, listen & master Japanese — fast!';
  static const String mascotName = 'NekoSensei';
  static const String verifyDomain = 'https://nekosensei.app/verify';

  /// Daily 5-minute boost lesson XP
  static const int xpDailyBoost = 30;
  static const int xpSpeakPractice = 15;
  static const int xpQuickReview = 20;
  static const int dailyBoostMinutes = 5;

  static const int xpLessonComplete = 25;
  static const int xpQuizPerfect = 50;
  static const int xpDailyStreak = 10;
  static const int xpExamPass = 200;

  static const List<int> levelXpThresholds = [
    0, 100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000,
  ];

  static const int examTotalMarks = 100;
  static const int examPassingScore = 70;
  static const int examSectionMarks = 20;

  static const Map<String, CertificateLevelInfo> certificateLevels = {
    'N5': CertificateLevelInfo(
      id: 'N5',
      title: 'N5 Beginner',
      subtitle: 'Japanese Language Foundation',
      requiredModuleIds: ['hiragana', 'katakana', 'vocabulary', 'grammar'],
      examId: 'exam_n5',
      color: 0xFFE53935,
    ),
    'N4': CertificateLevelInfo(
      id: 'N4',
      title: 'N4 Elementary',
      subtitle: 'Elementary Japanese Proficiency',
      requiredModuleIds: ['conversations', 'reading_writing'],
      examId: 'exam_n4',
      prerequisiteLevel: 'N5',
      color: 0xFF1565C0,
    ),
    'N3': CertificateLevelInfo(
      id: 'N3',
      title: 'N3 Intermediate',
      subtitle: 'Intermediate Japanese Proficiency',
      requiredModuleIds: ['jlpt_prep'],
      examId: 'exam_n3',
      prerequisiteLevel: 'N4',
      color: 0xFF58CC02,
    ),
  };
}

class CertificateLevelInfo {
  const CertificateLevelInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.requiredModuleIds,
    required this.examId,
    this.prerequisiteLevel,
    required this.color,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> requiredModuleIds;
  final String examId;
  final String? prerequisiteLevel;
  final int color;
}
