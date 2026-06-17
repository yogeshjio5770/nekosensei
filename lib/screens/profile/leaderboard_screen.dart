import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../utils/platform_layout.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.castle),
            tooltip: 'Guilds & Dojos',
            onPressed: () => context.push('/dojos'),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(progressServiceProvider).getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return const Center(child: Text('No learners yet'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
              child: ListView.builder(
                padding: PlatformLayout.pagePadding(context),
                itemCount: entries.length,
                itemBuilder: (_, i) {
                  final entry = entries[i];
                  final isTop3 = entry.rank <= 3;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isTop3
                        ? AppColors.xpGold.withValues(alpha: 0.1)
                        : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isTop3
                            ? AppColors.xpGold.withValues(alpha: 0.3)
                            : AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          '#${entry.rank}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isTop3 ? AppColors.xpGold : AppColors.primary,
                          ),
                        ),
                      ),
                      title: Text(entry.displayName),
                      subtitle: Text('${entry.xpPoints} XP'),
                      trailing: entry.rank == 1
                          ? const Icon(Icons.emoji_events, color: AppColors.xpGold)
                          : null,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
