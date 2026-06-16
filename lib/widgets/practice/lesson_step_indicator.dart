import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../models/lesson_models.dart';

class LessonStepIndicator extends StatelessWidget {
  const LessonStepIndicator({
    super.key,
    required this.current,
  });

  final LessonStep current;

  static const steps = [
    (LessonStep.learn, 'Learn', Icons.menu_book),
    (LessonStep.listen, 'Listen', Icons.hearing),
    (LessonStep.speak, 'Speak', Icons.mic),
    (LessonStep.quiz, 'Quiz', Icons.quiz),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = steps.indexWhere((s) => s.$1 == current);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          final done = i < currentIndex;
          final active = i == currentIndex;

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  width: active ? 42 : 36,
                  height: active ? 42 : 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? AppColors.success
                        : active
                            ? AppColors.primary
                            : AppColors.skillPath,
                    border: Border.all(
                      color: done
                          ? AppColors.successDark
                          : active
                              ? AppColors.primaryDark
                              : AppColors.skillLocked,
                      width: active ? 3 : 2,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    done ? Icons.check : step.$3,
                    color: done || active
                        ? Colors.white
                        : AppColors.lightTextSecondary,
                    size: active ? 20 : 18,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: active ? 11 : 10,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active
                        ? AppColors.primary
                        : AppColors.lightTextSecondary,
                  ),
                  child: Text(step.$2),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
