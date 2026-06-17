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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: value > 0
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: SizedBox(
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.skillPath),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent,
                            AppColors.nekoOrange,
                            AppColors.primary,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gloss / shine layer
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.35),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.6],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
