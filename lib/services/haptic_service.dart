import 'package:flutter/services.dart';

class HapticService {
  HapticService._();

  static Future<void> lightTap() => HapticFeedback.lightImpact();
  static Future<void> mediumTap() => HapticFeedback.mediumImpact();
  static Future<void> heavyTap() => HapticFeedback.heavyImpact();
  static Future<void> selection() => HapticFeedback.selectionClick();

  static Future<void> correctAnswer() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  static Future<void> wrongAnswer() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    await HapticFeedback.heavyImpact();
  }

  static Future<void> celebration() async {
    for (var i = 0; i < 3; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
