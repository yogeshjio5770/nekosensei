import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../services/pet_service.dart';
import '../../utils/platform_layout.dart';
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
        
        MascotMood currentMood = MascotMood.idle;
        if (user.petHealth < 30) currentMood = MascotMood.crying;
        else if (user.petHealth > 80 && user.petHunger > 80) currentMood = MascotMood.cheering;
        else if (user.petHunger < 40) currentMood = MascotMood.neutral;

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
                        padding: PlatformLayout.pagePadding(context),
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
                child: PlatformLayout.centeredContent(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NekoMascot(
                            size: 100,
                            mood: currentMood,
                            showSpeechBubble: user.petHealth < 30 
                                ? 'I feel sick... にゃ...' 
                                : user.petHunger < 40 
                                    ? 'I am hungry! 🐟'
                                    : 'Let\'s keep learning! にゃ〜',
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pet Health', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: user.petHealth / 100,
                                  color: user.petHealth < 30 ? Colors.red : Colors.green,
                                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                ),
                                const SizedBox(height: 8),
                                Text('Pet Hunger', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: user.petHunger / 100,
                                  color: user.petHunger < 40 ? Colors.orange : Colors.blue,
                                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: user.progressPercentage / 100,
                          minHeight: 14,
                          backgroundColor: AppColors.skillPath,
                          color: AppColors.success,
                        ),
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

class _QuickActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 3 : width >= 640 ? 3 : 2;
    final actions = [
      _QuickActionConfig(
        icon: Icons.sports_kabaddi,
        label: 'Live Battle',
        subtitle: '60s PvP',
        color: AppColors.error,
        onTap: () => context.push('/battle'),
      ),
      _QuickActionConfig(
        icon: Icons.groups,
        label: 'Dojos',
        subtitle: 'Guild',
        color: AppColors.nekoOrange,
        onTap: () => context.push('/dojos'),
      ),
      _QuickActionConfig(
        icon: Icons.workspace_premium,
        label: 'Keigo',
        subtitle: 'AI RP',
        color: AppColors.primary,
        onTap: () => context.push('/keigo-roleplay'),
      ),
      _QuickActionConfig(
        icon: Icons.refresh,
        label: 'Quick Review',
        subtitle: 'SRS',
        color: AppColors.secondary,
        onTap: () => context.push('/quick-review'),
      ),
      _QuickActionConfig(
        icon: Icons.mic,
        label: 'Speak',
        subtitle: 'Role-play',
        color: AppColors.success,
        onTap: () => context.push('/conversation-practice'),
      ),
      _QuickActionConfig(
        icon: Icons.restaurant,
        label: 'Feed Neko',
        subtitle: 'Pet',
        color: AppColors.accent,
        onTap: () async {
          await ref.read(petServiceProvider).feedPet();
          ref.invalidate(currentUserProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('NekoSensei fed! にゃ〜 🐟')),
            );
          }
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn Fast Today',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: columns == 2 ? 1.5 : 1.25,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _ActionCard(
              icon: action.icon,
              label: action.label,
              subtitle: action.subtitle,
              color: action.color,
              onTap: action.onTap,
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionConfig {
  const _QuickActionConfig({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: widget.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _scale = 0.95),
          onTapUp: (_) => setState(() => _scale = 1.0),
          onTapCancel: () => setState(() => _scale = 1.0),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.color.withValues(alpha: 0.4), width: 2),
            ),
            child: Column(
              children: [
                Icon(widget.icon, color: widget.color, size: 28),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: widget.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(widget.subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

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
