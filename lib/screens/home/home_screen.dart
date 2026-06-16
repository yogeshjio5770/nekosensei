import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/neko_mascot.dart';
import '../../widgets/home/skill_tree_path.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading profile')),
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const SizedBox.shrink();
        }

        final nodes = SkillTreePath.buildNodes(user.completedLessons);

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(currentUserProvider),
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondary,
                          AppColors.secondaryDark,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'こんにちは!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      Text(
                                        user.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      context.push('/leaderboard'),
                                  icon: const Icon(Icons.leaderboard,
                                      color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      context.push('/why-nekosensei'),
                                  tooltip: 'Why NekoSensei',
                                  icon: const Icon(Icons.auto_awesome,
                                      color: AppColors.accent),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _HeaderStat(
                                  icon: Icons.star,
                                  value: '${user.xpPoints}',
                                  label: 'XP',
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 12),
                                _HeaderStat(
                                  icon: Icons.local_fire_department,
                                  value: '${user.dailyStreak}',
                                  label: 'Streak',
                                  color: AppColors.warning,
                                  animate: user.dailyStreak > 0,
                                ),
                                const SizedBox(width: 12),
                                _HeaderStat(
                                  icon: Icons.military_tech,
                                  value: 'Lv.${user.levelFromXp}',
                                  label: 'Level',
                                  color: AppColors.success,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const NekoMascot(
                        size: 100,
                        mood: MascotMood.cheering,
                        showSpeechBubble: 'Let\'s keep learning! にゃ〜',
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.15, curve: Curves.elasticOut),
                      const SizedBox(height: 20),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: user.progressPercentage / 100),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 14,
                              backgroundColor: AppColors.skillPath,
                              color: AppColors.success,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${user.progressPercentage.toStringAsFixed(0)}% of course complete • ${user.completedLessons.length} lessons',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _QuickActions(),
                      const SizedBox(height: 24),
                      Text(
                        'Learning Path',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap a lesson node to start — finish each one to unlock the next!',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      SkillTreePath(
                        nodes: nodes,
                        onNodeTap: (lesson) =>
                            context.push('/lesson/${lesson.id}'),
                      ),
                      _CertificateBanner(user: user),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn Fast Today',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.bolt,
                label: 'Daily Boost',
                subtitle: '5 min',
                color: AppColors.warning,
                onTap: () => context.push('/daily-boost'),
                delayMs: 0,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionCard(
                icon: Icons.refresh,
                label: 'Quick Review',
                subtitle: 'SRS',
                color: AppColors.secondary,
                onTap: () => context.push('/quick-review'),
                delayMs: 80,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionCard(
                icon: Icons.mic,
                label: 'Speak',
                subtitle: 'Role-play',
                color: AppColors.primary,
                onTap: () => context.push('/conversation-practice'),
                delayMs: 160,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.08);
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.delayMs = 0,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    )
        .animate(delay: delayMs.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.animate = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, color: color, size: 22);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (animate)
              iconWidget
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.15, 1.15),
                    duration: 800.ms,
                  )
            else
              iconWidget,
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateBanner extends StatelessWidget {
  const _CertificateBanner({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final nextLevel = AppConstants.certificateLevels.entries
        .where((e) => !user.certificateLevels.contains(e.key))
        .firstOrNull;

    if (nextLevel == null) {
      return Card(
        color: AppColors.success.withValues(alpha: 0.12),
        child: ListTile(
          leading: const Icon(Icons.verified, color: AppColors.success),
          title: const Text('All certificates earned!'),
          subtitle: const Text('NekoSensei is proud of you! にゃん!'),
          onTap: () => context.push('/certificates'),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading:
            Icon(Icons.workspace_premium, color: Color(nextLevel.value.color)),
        title: Text('Earn ${nextLevel.value.title} Certificate'),
        subtitle: Text(nextLevel.value.subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/certificates'),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
