import 'package:flutter/material.dart';
import '../../config/constants.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.size,
    this.child,
    this.strokeWidth = 8,
  });

  final double progress;
  final double size;
  final Widget? child;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0, 1),
              strokeWidth: strokeWidth,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              color: AppColors.primary,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
