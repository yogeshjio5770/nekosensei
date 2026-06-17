import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/constants.dart';
import '../data/course_repository.dart';
import '../models/user_model.dart';
import '../models/lesson_models.dart';

class ProgressService {
  ProgressService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> completeLesson({
    required String userId,
    required String lessonId,
    required String moduleId,
    required int quizScore,
    required int xpEarned,
  }) async {
    try {
      await _completeLessonFirestore(
        userId: userId,
        lessonId: lessonId,
        moduleId: moduleId,
        quizScore: quizScore,
        xpEarned: xpEarned,
      );
    } catch (_) {
      // Silently skip when Firebase offline.
    }
  }

  Future<void> _completeLessonFirestore({
    required String userId,
    required String lessonId,
    required String moduleId,
    required int quizScore,
    required int xpEarned,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);
    final progressRef = userRef.collection('progress').doc(lessonId);

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) return;

      final data = userDoc.data()!;
      final completedLessons =
          List<String>.from(data['completedLessons'] ?? []);
      final completedModules =
          List<String>.from(data['completedModules'] ?? []);
      final earnedBadges = List<String>.from(data['earnedBadges'] ?? []);
      var xp = (data['xpPoints'] as int? ?? 0) + xpEarned;
      var streak = data['dailyStreak'] as int? ?? 0;
      final lastActive = data['lastActiveDate'] != null
          ? DateTime.parse(data['lastActiveDate'] as String)
          : null;

      streak = _calculateStreak(streak, lastActive);

      if (!completedLessons.contains(lessonId)) {
        completedLessons.add(lessonId);
      }

      transaction.set(progressRef, {
        'lessonId': lessonId,
        'moduleId': moduleId,
        'quizScore': quizScore,
        'xpEarned': xpEarned,
        'completedAt': DateTime.now().toIso8601String(),
      });

      transaction.update(userRef, {
        'completedLessons': completedLessons,
        'completedModules': completedModules,
        'earnedBadges': earnedBadges,
        'xpPoints': xp,
        'dailyStreak': streak,
        'lastActiveDate': DateTime.now().toIso8601String(),
        'currentLevel': _levelFromXp(xp),
      });
    });

    await _checkModuleCompletion(userId, moduleId);
    await _checkBadges(userId);
  }

  int _calculateStreak(int currentStreak, DateTime? lastActive) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastActive == null) return 1;

    final lastDay =
        DateTime(lastActive.year, lastActive.month, lastActive.day);
    final diff = today.difference(lastDay).inDays;

    if (diff == 0) return currentStreak;
    if (diff == 1) return currentStreak + 1;
    return 1;
  }

  int _levelFromXp(int xp) {
    for (var i = AppConstants.levelXpThresholds.length - 1; i >= 0; i--) {
      if (xp >= AppConstants.levelXpThresholds[i]) return i + 1;
    }
    return 1;
  }

  Future<void> _checkModuleCompletion(String userId, String moduleId) async {
    final lessons = CourseRepository.getLessonsForModule(moduleId);
    if (lessons.isEmpty) return;

    final lessonIds = lessons.map((l) => l.id).toList();
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final completed =
        List<String>.from(userDoc.data()?['completedLessons'] ?? []);

    if (lessonIds.every(completed.contains)) {
      await _firestore.collection('users').doc(userId).update({
        'completedModules': FieldValue.arrayUnion([moduleId]),
      });
    }
  }

  Future<void> _checkBadges(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    final data = userDoc.data()!;
    final xp = data['xpPoints'] as int? ?? 0;
    final streak = data['dailyStreak'] as int? ?? 0;
    final earned = List<String>.from(data['earnedBadges'] ?? []);
    final newBadges = <String>[];

    if (xp >= 100 && !earned.contains('first_100_xp')) {
      newBadges.add('first_100_xp');
    }
    if (streak >= 7 && !earned.contains('week_streak')) {
      newBadges.add('week_streak');
    }
    if (streak >= 30 && !earned.contains('month_streak')) {
      newBadges.add('month_streak');
    }

    if (newBadges.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update({
        'earnedBadges': FieldValue.arrayUnion(newBadges),
      });
    }
  }

  Future<List<AchievementModel>> getRecentAchievements(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return [];

    final badges = List<String>.from(userDoc.data()?['earnedBadges'] ?? []);
    return badges.map((id) {
      return AchievementModel(
        id: id,
        title: _badgeTitle(id),
        description: _badgeDescription(id),
        earnedAt: DateTime.now(),
        iconName: _badgeIcon(id),
      );
    }).toList();
  }

  String _badgeTitle(String id) => switch (id) {
        'first_100_xp' => 'First Steps',
        'week_streak' => 'Week Warrior',
        'month_streak' => 'Dedicated Learner',
        'hiragana_master' => 'Hiragana Master',
        'n5_certified' => 'N5 Certified',
        _ => 'Achievement',
      };

  String _badgeDescription(String id) => switch (id) {
        'first_100_xp' => 'Earned your first 100 XP',
        'week_streak' => '7-day learning streak',
        'month_streak' => '30-day learning streak',
        'hiragana_master' => 'Completed all Hiragana lessons',
        'n5_certified' => 'Passed the N5 certification exam',
        _ => 'Unlocked a new achievement',
      };

  String _badgeIcon(String id) => switch (id) {
        'first_100_xp' => 'star',
        'week_streak' => 'local_fire_department',
        'month_streak' => 'emoji_events',
        'hiragana_master' => 'translate',
        'n5_certified' => 'verified',
        _ => 'military_tech',
      };

  Stream<Map<String, dynamic>> watchUserAnalytics(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .snapshots()
        .map((snapshot) {
      final scores = snapshot.docs
          .map((d) => d.data()['quizScore'] as int? ?? 0)
          .toList();
      final avgScore = scores.isEmpty
          ? 0.0
          : scores.reduce((a, b) => a + b) / scores.length;

      return {
        'totalLessons': snapshot.docs.length,
        'averageScore': avgScore,
        'recentScores': scores.take(10).toList(),
      };
    });
  }

  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('xpPoints', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.asMap().entries.map((entry) {
        final data = entry.value.data();
        return LeaderboardEntry(
          userId: entry.value.id,
          displayName: data['displayName'] as String? ?? 'Learner',
          xpPoints: data['xpPoints'] as int? ?? 0,
          rank: entry.key + 1,
          photoUrl: data['photoUrl'] as String?,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updatePetStatus(String userId, int health, int hunger) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'petHealth': health,
        'petHunger': hunger,
      });
    } catch (_) {
      // Handle offline/demo mode silently
    }
  }
}
