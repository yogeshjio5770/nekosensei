import 'package:flutter/material.dart';
import '../../config/constants.dart';

class LessonProgressBar extends StatelessWidget {
  const LessonProgressBar({
    super.key,
    required this.progress,
    this.height = 16,
  });

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.skillPath),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.nekoOrange],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
