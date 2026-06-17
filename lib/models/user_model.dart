import 'package:equatable/equatable.dart';
import '../config/constants.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.currentLevel = 1,
    this.xpPoints = 0,
    this.dailyStreak = 0,
    this.petHealth = 100,
    this.petHunger = 100,
    this.dojoId,
    this.lastActiveDate,
    this.completedLessons = const [],
    this.completedModules = const [],
    this.earnedBadges = const [],
    this.certificateLevels = const [],
    this.fcmToken,
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
  final int petHealth;
  final int petHunger;
  final String? dojoId;
  final DateTime? lastActiveDate;
  final List<String> completedLessons;
  final List<String> completedModules;
  final List<String> earnedBadges;
  final List<String> certificateLevels;
  final String? fcmToken;
  final bool isAdmin;
  final DateTime? createdAt;

  String get name => displayName ?? email.split('@').first;

  double get progressPercentage {
    const total = AppConstants.totalLessons;
    if (total == 0) return 0;
    return (completedLessons.length / total * 100).clamp(0, 100);
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
    int? petHealth,
    int? petHunger,
    String? dojoId,
    DateTime? lastActiveDate,
    List<String>? completedLessons,
    List<String>? completedModules,
    List<String>? earnedBadges,
    List<String>? certificateLevels,
    String? fcmToken,
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
      petHealth: petHealth ?? this.petHealth,
      petHunger: petHunger ?? this.petHunger,
      dojoId: dojoId ?? this.dojoId,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedLessons: completedLessons ?? this.completedLessons,
      completedModules: completedModules ?? this.completedModules,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      certificateLevels: certificateLevels ?? this.certificateLevels,
      fcmToken: fcmToken ?? this.fcmToken,
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
      petHealth: map['petHealth'] as int? ?? 100,
      petHunger: map['petHunger'] as int? ?? 100,
      dojoId: map['dojoId'] as String?,
      lastActiveDate: map['lastActiveDate'] != null
          ? DateTime.parse(map['lastActiveDate'] as String)
          : null,
      completedLessons: List<String>.from(map['completedLessons'] ?? []),
      completedModules: List<String>.from(map['completedModules'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      certificateLevels: List<String>.from(map['certificateLevels'] ?? []),
      fcmToken: map['fcmToken'] as String?,
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
      'petHealth': petHealth,
      'petHunger': petHunger,
      'dojoId': dojoId,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'completedLessons': completedLessons,
      'completedModules': completedModules,
      'earnedBadges': earnedBadges,
      'certificateLevels': certificateLevels,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uid, email, xpPoints, dailyStreak, petHealth, petHunger, fcmToken];
}
