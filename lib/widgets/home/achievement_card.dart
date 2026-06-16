import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/lesson_models.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});

  final AchievementModel achievement;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: AppColors.xpGold, size: 32),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
