import 'package:flutter/material.dart';
import '../../config/constants.dart';
import 'celebration_overlay.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreakFlame(streak: streak),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak day${streak == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Daily streak',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
