import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.currentLevel = 1,
    this.xpPoints = 0,
    this.dailyStreak = 0,
    this.lastActiveDate,
    this.completedLessons = const [],
    this.completedModules = const [],
    this.earnedBadges = const [],
    this.certificateLevels = const [],
    this.isAdmin = false,
    this.createdAt,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int currentLevel;
  final int xpPoints;
  final int dailyStreak;
  final DateTime? lastActiveDate;
  final List<String> completedLessons;
  final List<String> completedModules;
  final List<String> earnedBadges;
  final List<String> certificateLevels;
  final bool isAdmin;
  final DateTime? createdAt;

  String get name => displayName ?? email.split('@').first;

  double get progressPercentage {
    const totalLessons = 42;
    if (totalLessons == 0) return 0;
    return (completedLessons.length / totalLessons * 100).clamp(0, 100);
  }

  int get levelFromXp {
    final thresholds = [0, 100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000];
    for (var i = thresholds.length - 1; i >= 0; i--) {
      if (xpPoints >= thresholds[i]) return i + 1;
    }
    return 1;
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? currentLevel,
    int? xpPoints,
    int? dailyStreak,
    DateTime? lastActiveDate,
    List<String>? completedLessons,
    List<String>? completedModules,
    List<String>? earnedBadges,
    List<String>? certificateLevels,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      currentLevel: currentLevel ?? this.currentLevel,
      xpPoints: xpPoints ?? this.xpPoints,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedLessons: completedLessons ?? this.completedLessons,
      completedModules: completedModules ?? this.completedModules,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      certificateLevels: certificateLevels ?? this.certificateLevels,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      currentLevel: map['currentLevel'] as int? ?? 1,
      xpPoints: map['xpPoints'] as int? ?? 0,
      dailyStreak: map['dailyStreak'] as int? ?? 0,
      lastActiveDate: map['lastActiveDate'] != null
          ? DateTime.parse(map['lastActiveDate'] as String)
          : null,
      completedLessons: List<String>.from(map['completedLessons'] ?? []),
      completedModules: List<String>.from(map['completedModules'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      certificateLevels: List<String>.from(map['certificateLevels'] ?? []),
      isAdmin: map['isAdmin'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'currentLevel': currentLevel,
      'xpPoints': xpPoints,
      'dailyStreak': dailyStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'completedLessons': completedLessons,
      'completedModules': completedModules,
      'earnedBadges': earnedBadges,
      'certificateLevels': certificateLevels,
      'isAdmin': isAdmin,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uid, email, xpPoints, dailyStreak];
}
