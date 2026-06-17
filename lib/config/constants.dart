import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // NekoSensei brand palette — Modern, Japanese-inspired minimalist design
  static const Color primary = Color(0xFFFF5252);
  static const Color primaryDark = Color(0xFFD32F2F);
  static const Color primaryLight = Color(0xFFFFEBEE);
  static const Color secondary = Color(0xFF2962FF);
  static const Color secondaryDark = Color(0xFF1565C0);
  static const Color secondaryLight = Color(0xFFE3F2FD);
  static const Color accent = Color(0xFFFFAB00);
  static const Color accentDark = Color(0xFFFF6F00);
  static const Color accentLight = Color(0xFFFFECB3);
  static const Color nekoOrange = Color(0xFFFF7043);
  static const Color bellGold = Color(0xFFFFD54F);

  static const Color success = Color(0xFF00E676);
  static const Color successDark = Color(0xFF00C853);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFAB00);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color error = Color(0xFFFF1744);
  static const Color errorDark = Color(0xFFD50000);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color xpGold = Color(0xFFFFD700);

  // Neutral palette for clean design
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color neutral200 = Color(0xFFFAFAFA);
  static const Color neutral300 = Color(0xFFF5F5F5);
  static const Color neutral400 = Color(0xFFE0E0E0);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF616161);
  static const Color neutral700 = Color(0xFF424242);
  static const Color neutral800 = Color(0xFF212121);
  static const Color neutral900 = Color(0xFF121212);

  static const Color lightBackground = neutral200;
  static const Color lightSurface = neutral100;
  static const Color lightText = neutral800;
  static const Color lightTextSecondary = neutral600;
  static const Color lightBorder = neutral400;

  static const Color darkBackground = neutral900;
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = neutral200;
  static const Color darkTextSecondary = neutral500;
  static const Color darkBorder = Color(0xFF333333);

  static const Color skillPath = neutral400;
  static const Color skillLocked = neutral400;
}

class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/nekosensei_logo.png';
}

class AppConstants {
  AppConstants._();

  static const String appName = 'NekoSensei';
  static const String appTagline = 'Learn Japanese with NekoSensei';
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

  /// Total lessons on the skill tree — keep in sync with course_repository.
  static const int totalLessons = 38;

  static const Map<String, CertificateLevelInfo> certificateLevels = {
    'N5': CertificateLevelInfo(
      id: 'N5',
      title: 'N5 Beginner',
      subtitle: 'Japanese Language Foundation',
      requiredModuleIds: ['unit_1', 'unit_2', 'unit_3', 'unit_4'],
      examId: 'exam_n5',
      color: 0xFFFF5252,
    ),
    'N4': CertificateLevelInfo(
      id: 'N4',
      title: 'N4 Elementary',
      subtitle: 'Elementary Japanese Proficiency',
      requiredModuleIds: ['unit_5', 'unit_6'],
      examId: 'exam_n4',
      prerequisiteLevel: 'N5',
      color: 0xFF2962FF,
    ),
    'N3': CertificateLevelInfo(
      id: 'N3',
      title: 'N3 Intermediate',
      subtitle: 'Intermediate Japanese Proficiency',
      requiredModuleIds: ['unit_7'],
      examId: 'exam_n3',
      prerequisiteLevel: 'N4',
      color: 0xFF00E676,
    ),
    'N2': CertificateLevelInfo(
      id: 'N2',
      title: 'N2 Pre-Advanced',
      subtitle: 'Pre-Advanced Japanese Proficiency',
      requiredModuleIds: [],
      examId: 'exam_n2',
      prerequisiteLevel: 'N3',
      color: 0xFFFFAB00,
    ),
    'N1': CertificateLevelInfo(
      id: 'N1',
      title: 'N1 Expert',
      subtitle: 'Expert Japanese Proficiency',
      requiredModuleIds: [],
      examId: 'exam_n1',
      prerequisiteLevel: 'N2',
      color: 0xFF7C4DFF,
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
